# ===== PR title =====
warn('PR is classed as Work in Progress') if github.pr_title.include? '[WIP]'

# ===== diff size =====
warn('PRの変更量が多すぎます。PRを分割しましょう！') if git.lines_of_code > 500

# ===== Test =====
raise('テストが書かれていません！') if `grep -r fdescribe specs/ `.length > 1
raise('テストが書かれていません！') if `grep -r fit specs/ `.length > 1
# ===== Label ====
labels = github.pr_labels
warn('labelを選択してください！') if labels.empty?
