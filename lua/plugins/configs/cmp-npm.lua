local ok, npm = pcall(require, "cmp-npm")

if not ok then
	return
end

npm.setup({})
