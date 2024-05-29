local api = require("taboo.api")

describe("api", function()
	it("filename_without_path", function()
		assert.equals(api.filename_without_path("path/to/file.lua"), "file.lua")
		assert.equals(api.filename_without_path("file.lua"), "file.lua")
	end)

	it("should_ignore_buffer", function()
		assert.equals(api.should_ignore_buffer({ "foo" }, "foo_bar"), true)
		assert.equals(api.should_ignore_buffer({ "bar" }, "foo"), false)
	end)
end)
