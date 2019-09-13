if [ "$BRANCH_NAME" == 'master' ]
then
  export S3_BUNDLE_PATH='docs.sustainabilitytool.com/stable/'

else
  export S3_BUNDLE_PATH='docs.sustainabilitytool.com/latest/'
fi

export AWS_SECRET_ACCESS_KEY=$(eval $(jx get vault-config) && /builder/home/.jx/bin/vault kv get secret/pipelines/aws | grep -P -o "\d\w{2}\d\w{8,}")
export AWS_ACCESS_KEY_ID=$(eval $(jx get vault-config) && /builder/home/.jx/bin/vault kv get secret/pipelines/aws | grep -P -o "[A-Z]{6}\d\w.*")
export AWS_STORAGE_BUCKET_KEY=$(eval $(jx get vault-config) && /builder/home/.jx/bin/vault kv get secret/pipelines/aws | grep -P -o "[a-z]{5}-.*")

echo "ENV VARS:" "$AWS_S3_REGION_NAME" "$AWS_S3_HOST" "$AWS_S3_USE_SSL"
#echo "SECRETS" "$AWS_SECRET_ACCESS_KEY" "$AWS_ACCESS_KEY_ID" "$AWS_STORAGE_BUCKET_KEY"
echo "Uploading files to ${S3_BUNDLE_PATH}"

jx step stash -c bundles -p site/ -t "$S3_BUNDLE_PATH" --bucket-url s3://procedural-frontend-bundles --verbose