local api = require("taboo.api")

describe("api", function ()
	it("can be required", function ()
		assert.equals(api._filename_without_path("path/to/file.lua"), "file.lua")
		assert.equals(api._filename_without_path("file.lua"), "file.lua")
	end)
end)
