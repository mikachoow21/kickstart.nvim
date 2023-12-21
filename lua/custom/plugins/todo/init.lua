local M = {}


function M.insert_todo()
    local sqlite = require("custom.plugins.todo.ljsqlite3")
    local todo_desc = ""
    repeat
        todo_desc = vim.fn.input("Enter description: ")
        print("")
    until (todo_desc ~= "") and (string.len(todo_desc) <= 150)
    local db = sqlite.open("./todo.db")

    db:exec("INSERT INTO todo_list (description) VALUES ('" .. todo_desc .. "');")
    db:close()
end

function M.fetch_todos()
    local sqlite = require("custom.plugins.todo.ljsqlite3")
    local db = sqlite.open("./todo.db")
    local res = db:exec("SELECT * FROM todo_list WHERE completed == 'No';")
    for _, item in ipairs(res[2]) do print(item) end
    db:close()
end

function M.complete_todos()
    local sqlite = require("custom.plugins.todo.ljsqlite3")
    local db = sqlite.open("todo.db")

    local todo_completed = -1
    local todo_selected = -1
    repeat
        local res = db:exec("SELECT * FROM todo_list WHERE completed == 'No';")
        for i, item in ipairs(res[2]) do
            print(tostring(tonumber(res[1][i])) .. ': ' .. item)
        end
        todo_selected = tonumber(vim.fn.input("Enter an ID num for task listed above: "))
        for _, id in ipairs(res[1]) do
            if (id == todo_selected) then todo_completed = todo_selected end
        end

        print("")
    until todo_completed >= 0

    db:exec("UPDATE todo_list SET completed = 'Yes' WHERE id = " .. todo_completed .. " AND completed = 'No';")
    db:close()
end

vim.api.nvim_create_user_command('InsertTodo', M.insert_todo, {})
vim.api.nvim_create_user_command('FetchTodo', M.fetch_todos, {})
vim.api.nvim_create_user_command('CompleteTodo', M.complete_todos, {})

return {}
