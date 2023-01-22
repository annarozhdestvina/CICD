#!/bin/bash
TELEGRAM_BOT_TOKEN=5599930379:AAHYGhQGsZc0Gn1LWgQbYZLvJCGwBjR2Ky4
TIME="10"
URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
TEXT="Job Name: $CI_JOB_NAME%0AStatus: $CI_JOB_STATUS%0A%0APipeline:$CI_PIPELINE_IID%0AProject:+$CI_PROJECT_NAME%0AURL:+$CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID/%0ABranch:+$CI_COMMIT_REF_SLUG%0AMessage:+$CI_COMMIT_MESSAGE"


TELEGRAM_USER_ID=1295996461
TELEGRAM_USER_ID2=722828510

curl -s --max-time $TIME -d "chat_id=$TELEGRAM_USER_ID&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null
curl -s --max-time $TIME -d "chat_id=$TELEGRAM_USER_ID2&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null