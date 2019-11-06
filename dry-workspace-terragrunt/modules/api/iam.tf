##############################  API IAM ROLES ###################################################

resource "aws_iam_role" "api_role" {
  name = "${var.resource-prefix}-api-role${var.resource-suffix}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": [
                "iam:AddUserToGroup",
                "iam:AddClientIDToOpenIDConnectProvider",
                "iam:AttachGroupPolicy",
                "iam:CreateAccountAlias",
                "iam:CreateGroup",
                "iam:CreateOpenIDConnectProvider",
                "iam:CreateSAMLProvider",
                "iam:CreateUser",
                "iam:CreateVirtualMFADevice",
                "iam:DeactivateMFADevice",
                "iam:DeleteAccountAlias",
                "iam:DeleteAccountPasswordPolicy",
                "iam:DeleteGroup",
                "iam:DeleteGroupPolicy",
                "iam:DeleteLoginProfile",
                "iam:DeleteOpenIDConnectProvider",
                "iam:DeleteSAMLProvider",
                "iam:DeleteSSHPublicKey",
                "iam:DeleteSigningCertificate",
                "iam:DeleteUser",
                "iam:DeleteVirtualMFADevice",
                "iam:DetachGroupPolicy",
                "iam:EnableMFADevice",
                "iam:PutGroupPolicy",
                "iam:RemoveClientIDFromOpenIDConnectProvider",
                "iam:RemoveUserFromGroup",
                "iam:ResyncMFADevice",
                "iam:UpdateAccountPasswordPolicy",
                "iam:UpdateAssumeRolePolicy",
                "iam:UpdateGroup",
                "iam:UpdateLoginProfile",
                "iam:UpdateOpenIDConnectProviderThumbprint",
                "iam:UpdateSAMLProvider",
                "iam:UpdateSSHPublicKey",
                "iam:UpdateSigningCertificate",
                "iam:UpdateUser",
                "iam:UploadSSHPublicKey",
                "iam:UploadSigningCertificate",
                "sts:AssumeRoleWithSAML",
                "sts:AssumeRoleWithWebIdentity",
                "iam:TagRole",
                "iam:UntagRole",
                "iam:TagUser",
                "iam:UntagUser"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "api_dynamo_access" {
  role       = "${aws_iam_role.api_role.name}"
  policy_arn = "${var.persistence-ro-policy-arn}"
}