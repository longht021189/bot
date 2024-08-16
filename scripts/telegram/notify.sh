set -e

MESSAGE="*Build Success*
\\- Name: $OUTPUT_NAME
\\- [Download Here]($OUTPUT_LINK)"

curl -L https://api.telegram.org/bot$TELEGRAM_BOT_API_TOKEN/sendMessage \
  -X POST \
  -H 'Content-Type: multipart/form-data' \
  -F chat_id=$TELEGRAM_BOT_ME_CHAT_ID \
  -F parse_mode=MarkdownV2 \
  -F text="$MESSAGE"

# Docs: https://core.telegram.org/bots/api#sendmessage