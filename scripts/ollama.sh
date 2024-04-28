echo "coding"
ollama create custom-coding-model -f ./ollama/coding > /dev/null

echo "communications"
ollama create custom-communications-model -f ./ollama/communications > /dev/null
