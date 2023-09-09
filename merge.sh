#!/bin/bash


for file in lists/*.json; do
  echo "start to snapshot $file"
  cat "$file" | jq -c '.data.list.members_timeline.timeline.instructions[] | select(.type=="TimelineAddEntries") | .entries[].content.itemContent.user_results.result  | select(.!=null) | {name: .legacy.screen_name, nick_name: .legacy.name, id: .rest_id}' | jq -s . > $file.snapshot
  echo "merge $file data"
  touch $file.total
  jq -s 'add | unique_by(.id)' $file.total $file.snapshot > temp.json && mv temp.json $file.total
  touch lists.total
  jq -s 'add | unique_by(.id)' $file.total lists.total > temp.json && mv temp.json lists.total
  echo "$file done"
done

# enbable when reformatting block.json
# touch all.total
# jq -s 'add | unique_by(.id)' block.json lists.total > temp.json && mv temp.json all.total
