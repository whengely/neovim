local status_ok, neogit = pcall(require, "neogit")
if not status_ok then
	return
end

local setup = {
	auto_refresh = true,
	commit_popup = { kind = "split" },
	integrations = { diffview = true },
	mappings = { status = { ["B"] = "BranchPopup" } },
}

neogit.setup(setup)
