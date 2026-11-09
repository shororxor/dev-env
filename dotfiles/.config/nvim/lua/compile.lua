-- Compile and run single files and whole language projects.

-- Java: use Homebrew OpenJDK for all Java tooling started by Neovim (jdtls, javac, ...)
-- For bug on mac only
local java_home = '/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home'
if vim.fn.isdirectory(java_home) == 1 then
    vim.env.JAVA_HOME = java_home
    vim.env.PATH = java_home .. '/bin:' .. vim.env.PATH
end

-- OCaml: make the opam switch binaries available to Neovim (ocamllsp, ocamlopt, dune, ...)
local opam_bin = vim.fn.expand('~/.opam/default/bin')
if vim.fn.isdirectory(opam_bin) == 1 then
    vim.env.PATH = opam_bin .. ':' .. vim.env.PATH
end

-- Compile current buffer with the given command
local function compile_buffer(name, exts, build_cmd)
    local src = vim.api.nvim_buf_get_name(0)
    if src == '' then
        vim.notify('Save the buffer before compiling', vim.log.levels.WARN)
        return
    end

    local ext = vim.fn.fnamemodify(src, ':e')
    if not vim.tbl_contains(exts, ext) then
        vim.notify(name .. ' cannot compile .' .. ext .. ' files', vim.log.levels.WARN)
        return
    end

    vim.cmd.write()
    local cmd, out = build_cmd(src)

    vim.system(cmd, { text = true }, function(result)
        vim.schedule(function()
            if result.code == 0 then
                local msg = 'Compiled ' .. vim.fn.fnamemodify(src, ':t')
                if out then
                    msg = msg .. ' -> ' .. vim.fn.fnamemodify(out, ':t')
                end
                vim.notify(msg, vim.log.levels.INFO)
            else
                vim.notify(result.stderr ~= '' and result.stderr or 'Compilation failed', vim.log.levels.ERROR)
            end
        end)
    end)
end

-- g++ for C/C++ (main.cpp -> main)
vim.keymap.set('n', '<leader>cc', function()
    compile_buffer('g++', { 'c', 'cc', 'cpp', 'cxx' }, function(src)
        local out = vim.fn.fnamemodify(src, ':r')
        return { 'g++', src, '-o', out }, out
    end)
end, { desc = 'Compile current C/C++ file with g++' })

-- javac for Java (Main.java -> Main.class)
vim.keymap.set('n', '<leader>cj', function()
    compile_buffer('javac', { 'java' }, function(src)
        return { 'javac', src }
    end)
end, { desc = 'Compile current Java file with javac' })

-- rustc for Rust (main.rs -> main)
vim.keymap.set('n', '<leader>cr', function()
    compile_buffer('rustc', { 'rs' }, function(src)
        local out = vim.fn.fnamemodify(src, ':r')
        return { 'rustc', '--edition', '2021', src, '-o', out }, out
    end)
end, { desc = 'Compile current Rust file with rustc' })

-- ocamlopt for OCaml (main.ml -> main)
vim.keymap.set('n', '<leader>co', function()
    compile_buffer('ocamlopt', { 'ml' }, function(src)
        local out = vim.fn.fnamemodify(src, ':r')
        return { 'ocamlopt', src, '-o', out }, out
    end)
end, { desc = 'Compile current OCaml file with ocamlopt' })

-- go build for Go (main.go -> main)
vim.keymap.set('n', '<leader>cg', function()
    compile_buffer('go', { 'go' }, function(src)
        local out = vim.fn.fnamemodify(src, ':r')
        return { 'go', 'build', '-o', out, src }, out
    end)
end, { desc = 'Compile current Go file with go build' })

-- dotnet build for C# (file-based app)
vim.keymap.set('n', '<leader>cs', function()
    compile_buffer('dotnet', { 'cs' }, function(src)
        return { 'dotnet', 'build', src }, nil
    end)
end, { desc = 'Compile current C# file with dotnet build' })

-- Run the current language project in a tmux pane (build + run).
-- Existing standalone-file compile keymaps above are left unchanged.
local function project_root()
    return vim.fs.root(0, { '.git' }) or vim.fn.getcwd()
end

local projects = {
    cpp = { dir = 'cpp', cmd = 'cmake -S . -B build && cmake --build build && ./build/bin/main' },
    java = { dir = 'java', cmd = 'mvn -q package -DskipTests && java -jar target/main.jar' },
    rust = { dir = 'rust', cmd = 'cargo run --quiet' },
    ocaml = { dir = 'ocaml', cmd = 'dune build && ./_build/default/bin/main.exe' },
    go = { dir = 'go', cmd = 'go run .' },
    csharp = { dir = 'csharp', cmd = 'dotnet run' },
    python = { dir = 'python', cmd = 'uv run main' },
    typescript = { dir = 'typescript', cmd = 'npm run build && node dist/main.js' },
}

local function run_project(name, with_input)
    local src = vim.api.nvim_buf_get_name(0)
    if src == '' then
        vim.notify('Save the buffer before running', vim.log.levels.WARN)
        return
    end

    local project = projects[name]
    if not project then
        vim.notify('Unknown project: ' .. name, vim.log.levels.ERROR)
        return
    end

    local ok, err = pcall(vim.cmd.write)
    if not ok then
        vim.notify('Could not save buffer: ' .. tostring(err), vim.log.levels.ERROR)
        return
    end

    local root = project_root()
    local cwd = root .. '/' .. project.dir

    if vim.fn.isdirectory(cwd) == 0 then
        vim.notify('Project directory not found: ' .. cwd, vim.log.levels.ERROR)
        return
    end

    local base = string.format(
        'cd %s && %s',
        vim.fn.shellescape(cwd),
        project.cmd
    )
    if with_input then
        base = base .. ' < ' .. vim.fn.shellescape(root .. '/input.inp')
    end
    local cmd = base .. '; echo; echo "[done]"; exec bash'

    if vim.env.TMUX and vim.env.TMUX ~= '' then
        local pane = vim.g.cp_run_pane
        local panes = vim.fn.systemlist({ 'tmux', 'list-panes', '-F', '#{pane_id}' })

        if pane and vim.tbl_contains(panes, pane) then
            vim.fn.system({ 'tmux', 'send-keys', '-t', pane, 'C-c' })
            vim.fn.system({ 'tmux', 'send-keys', '-t', pane, cmd, 'Enter' })
            vim.fn.system({ 'tmux', 'select-pane', '-t', pane })
        else
            local new_pane = vim.fn.systemlist({
                'tmux',
                'split-window',
                '-h',
                '-c',
                cwd,
                '-P',
                '-F',
                '#{pane_id}',
                'bash',
                '-c',
                cmd,
            })[1]

            if new_pane and new_pane ~= '' then
                vim.g.cp_run_pane = new_pane
            else
                vim.notify('Failed to create tmux pane', vim.log.levels.ERROR)
            end
        end
    else
        -- Fallback when Neovim is not running inside tmux.
        vim.cmd('botright split')
        vim.cmd('terminal bash -c ' .. vim.fn.shellescape(cmd))
    end
end

-- Run without input (no redirection from input.inp)
vim.keymap.set('n', '<leader>cec', function()
    run_project('cpp', false)
end, { desc = 'Build and run C++ project (no input)' })
vim.keymap.set('n', '<leader>cej', function()
    run_project('java', false)
end, { desc = 'Build and run Java project (no input)' })
vim.keymap.set('n', '<leader>cer', function()
    run_project('rust', false)
end, { desc = 'Build and run Rust project (no input)' })
vim.keymap.set('n', '<leader>ceo', function()
    run_project('ocaml', false)
end, { desc = 'Build and run OCaml project (no input)' })
vim.keymap.set('n', '<leader>ceg', function()
    run_project('go', false)
end, { desc = 'Build and run Go project (no input)' })
vim.keymap.set('n', '<leader>ces', function()
    run_project('csharp', false)
end, { desc = 'Build and run C# project (no input)' })
vim.keymap.set('n', '<leader>cep', function()
    run_project('python', false)
end, { desc = 'Build and run Python project (no input)' })
vim.keymap.set('n', '<leader>cet', function()
    run_project('typescript', false)
end, { desc = 'Build and run TypeScript project (no input)' })

-- Run with input (reads from input.inp in the project root)
vim.keymap.set('n', '<leader>ceic', function()
    run_project('cpp', true)
end, { desc = 'Build and run C++ project (with input)' })
vim.keymap.set('n', '<leader>ceij', function()
    run_project('java', true)
end, { desc = 'Build and run Java project (with input)' })
vim.keymap.set('n', '<leader>ceir', function()
    run_project('rust', true)
end, { desc = 'Build and run Rust project (with input)' })
vim.keymap.set('n', '<leader>ceio', function()
    run_project('ocaml', true)
end, { desc = 'Build and run OCaml project (with input)' })
vim.keymap.set('n', '<leader>ceig', function()
    run_project('go', true)
end, { desc = 'Build and run Go project (with input)' })
vim.keymap.set('n', '<leader>ceis', function()
    run_project('csharp', true)
end, { desc = 'Build and run C# project (with input)' })
vim.keymap.set('n', '<leader>ceip', function()
    run_project('python', true)
end, { desc = 'Build and run Python project (with input)' })
vim.keymap.set('n', '<leader>ceit', function()
    run_project('typescript', true)
end, { desc = 'Build and run TypeScript project (with input)' })
