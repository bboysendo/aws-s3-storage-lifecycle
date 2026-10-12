#!/bin/bash
# Demonstrates S3 versioning: upload, overwrite twice, list versions, then
# restore the original version by copying it back over the current object.
#
# Usage: ./demo-versioning.sh <bucket-name>
set -euo pipefail

BUCKET="${1:?Usage: demo-versioning.sh <bucket-name>}"
KEY="demo/versioned-file.txt"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "== 1. Upload version 1 =="
echo "version 1 - original content" > "$TMP_DIR/v1.txt"
aws s3 cp "$TMP_DIR/v1.txt" "s3://${BUCKET}/${KEY}"

echo "== 2. Overwrite with version 2 =="
echo "version 2 - edited content" > "$TMP_DIR/v2.txt"
aws s3 cp "$TMP_DIR/v2.txt" "s3://${BUCKET}/${KEY}"

echo "== 3. Overwrite with version 3 =="
echo "version 3 - edited again" > "$TMP_DIR/v3.txt"
aws s3 cp "$TMP_DIR/v3.txt" "s3://${BUCKET}/${KEY}"

echo
echo "== 4. List all versions of ${KEY} =="
aws s3api list-object-versions --bucket "$BUCKET" --prefix "$KEY" \
  --query 'Versions[].{VersionId:VersionId,LastModified:LastModified,IsLatest:IsLatest,Size:Size}' \
  --output table

echo
echo "== 5. Current (latest) content =="
aws s3 cp "s3://${BUCKET}/${KEY}" -

echo
FIRST_VERSION_ID=$(aws s3api list-object-versions --bucket "$BUCKET" --prefix "$KEY" \
  --query 'Versions[?IsLatest==`false`] | sort_by(@, &LastModified)[0].VersionId' --output text)

if [ "$FIRST_VERSION_ID" = "None" ] || [ -z "$FIRST_VERSION_ID" ]; then
  echo "Could not determine the original version id — skipping restore demo."
  exit 0
fi

echo "== 6. Restore the original version (VersionId: ${FIRST_VERSION_ID}) by copying it back as the current version =="
aws s3api copy-object --bucket "$BUCKET" --key "$KEY" \
  --copy-source "${BUCKET}/${KEY}?versionId=${FIRST_VERSION_ID}" >/dev/null

echo "== 7. Current content after restore (should match version 1) =="
aws s3 cp "s3://${BUCKET}/${KEY}" -

echo
echo "Done. Versioning let us recover version 1's content without losing the edit history in between."
