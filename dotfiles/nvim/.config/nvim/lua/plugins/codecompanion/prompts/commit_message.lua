local function prompt(diff, log)
  return string.format(
    [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

```diff
%s
```

When unsure about the module names to use in the commit message, you can refer to the last 20 commit messages in this repository:

```
%s
```

Output only the commit message without any explanations and follow-up suggestions.
]],
    diff,
    log
  )
end

return prompt
