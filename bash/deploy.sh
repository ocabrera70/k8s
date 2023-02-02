#!/bin/bash
set -eo pipefail

environment=""
event_bridge_role=""
lambda_role=""
step_function_role=""
bucket=""
bucket_prefix=""
REGION='us-east-1'

POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
  -e | --environment)
    environment="$2"
    shift # past argument
    shift # past value
    ;;
  -ebr | --event-bridge-role)
    event_bridge_role="$2"
    shift # past argument
    shift # past value
    ;;
  -lr | --lambda-role)
    lambda_role="$2"
    shift # past argument
    shift # past value
    ;;
  -sfr | --step-function-role)
    step_function_role="$2"
    shift # past argument
    shift # past value
    ;;
  -b | --bucket)
    bucket="$2"
    shift # past argument
    shift # past value
    ;;
  -bp | --bucket-prefix)
    bucket_prefix="$2"
    shift # past argument
    shift # past value
    ;;
    #For flag options
    #    --create-file)
    #      create_file="yes"
    #      shift # past argument
    #      ;;
  -* | --*)
    echo "Unknown option $1"
    exit 1
    ;;
  *)
    POSITIONAL_ARGS+=("$1") # save positional arg
    shift                   # past argument
    ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [ -z "${environment}" ]; then
  environment="DEV"
fi

if [ -z "${bucket}" ]; then
  ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
  bucket="data-${ACCOUNT_ID}-${REGION}"
fi

if [ -z "${bucket_prefix}" ]; then
  bucket_prefix="config/"
fi

echo "Deploy Infra"
cdk_args=("--parameters" "Bucket=${bucket}" "--parameters" "BucketPrefix=${bucket_prefix}")
cdk_args+=("--parameters" "Environment=${environment}")
if ! [ -z "${event_bridge_role}" ]; then cdk_args+=("--parameters" "EventBridgeRole=${event_bridge_role}"); fi
if ! [ -z "${lambda_role}" ]; then cdk_args+=("--parameters" "LambdaRole=${lambda_role}"); fi
if ! [ -z "${step_function_role}" ]; then cdk_args+=("--parameters" "StepFunctionRole=${step_function_role}"); fi


cdk deploy "${cdk_args[@]}" --require-approval never
