" Maintainer:   Kacper Kocot <kocotian@kocotian.pl>

" Dividing Lines

function DiredGetLine(files, sid)
	let g:DiredLine = line('.')
	return a:files[g:DiredLine - 1]
endfunction

function DiredGetPermissions(files, sid)
	let line = DiredGetLine(a:files, a:sid)
	let suba = substitute(line, '^\s*.\ze..........*$', '', '')
	return substitute(suba, '.........\zs.*$', '', '')
endfunction

function DiredGetNumericPermissions(files, sid)
	let nperm = DiredGetPermissions(a:files, a:sid)
	let uperm = (nperm[0] == 'r' ? 4 : 0) + (nperm[1] == 'w' ? 2 : 0) + (nperm[2] == 'x' ? 1 : 0)
	let gperm = (nperm[3] == 'r' ? 4 : 0) + (nperm[4] == 'w' ? 2 : 0) + (nperm[5] == 'x' ? 1 : 0)
	let operm = (nperm[6] == 'r' ? 4 : 0) + (nperm[7] == 'w' ? 2 : 0) + (nperm[8] == 'x' ? 1 : 0)
	return uperm . gperm . operm
endfunction

function DiredGetUser(files, sid)
	let line = DiredGetLine(a:files, a:sid)
	let suba = substitute(line, '^\s*\S\+\s\+\S\+\s\+\ze.*', '', '')
	return substitute(suba, '\S\+\zs.*$', '', '')
endfunction

function DiredGetGroup(files, sid)
	let line = DiredGetLine(a:files, a:sid)
	let suba = substitute(line, '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\ze.*', '', '')
	return substitute(suba, '\S\+\zs.*$', '', '')
endfunction

function DiredGetFilename(files, sid, dereferenceLink)
	let line = DiredGetLine(a:files, a:sid)
	let filename = substitute(line, '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+', '', '')

	if substitute(line, '^\s*', '', '')[0] == 'l'
		if a:dereferenceLink == 1
			return substitute(filename, '.*-> ', '', '')
		else
			return substitute(filename, ' ->.*', '', '')
		endif
	else
		return filename
	endif
endfunction

" File management

function DiredDelete(files, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	silent execute "!rm -f '" . filename . "'>/dev/null"
	echo filename . " removed"
	silent call DiredMain(0, a:sid)
endfunction

function DiredDeleteRecur(files, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	let sure = input("Are you sure that you want to delete '" . filename . "' recursively? ")
	if sure[0] == 'y'
		silent execute "!rm -rf '" . filename . "'>/dev/null"
		echo filename . " removed recursively"
	endif
	silent call DiredMain(0, a:sid)
endfunction

function DiredChdir(files, sid)
	let g:DiredLine = line('.')
	call insert(g:DiredHistory, getcwd(), len(g:DiredHistory))
	if substitute(a:files[g:DiredLine - 1], '^\s*', '', '')[0] == 'd'
		let filename = DiredGetFilename(a:files, a:sid, 0)
		silent execute "chdir " . filename
		silent call DiredMain(0, a:sid)
	elseif substitute(a:files[g:DiredLine - 1], '^\s*', '', '')[0] == 'l'
		let filename = DiredGetFilename(a:files, a:sid, 0)
		let filename = substitute(filename, '.*-> ', '', '')
		silent execute "chdir " . filename
		silent call DiredMain(0, a:sid)
	else
		silent call DiredEdit(a:files, 2, a:sid)
	endif
endfunction

function DiredRename(files, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	let newfilename = input("Give new file name: ", filename)
	silent execute "!mv '" . filename . "' '" . newfilename . "'>/dev/null"
	silent call DiredMain(0, a:sid)
endfunction

function DiredMkdir(files, sid)
	let filename = input("Give directory name: ")
	silent execute "!mkdir -p '" . filename . "'"
	silent call DiredMain(0, a:sid)
endfunction

function DiredTouch(files, sid)
	let g:DiredLine = line('.')
	let filename = substitute(a:files[g:DiredLine - 1], '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+', '', '')
	silent execute "!touch '" . filename . "'"
	silent call DiredMain(0, a:sid)
endfunction

function DiredNewfile(files, sid)
	let filename = input("Give filename: ")
	silent execute "!touch '" . filename . "'"
	silent call DiredMain(0, a:sid)
endfunction

function DiredEdit(files, splitted, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	if a:splitted == 0
		silent execute "edit " . filename
	elseif a:splitted == 1
		silent execute "split " . filename
	elseif a:splitted == 2
		silent execute "vsplit " . filename
	endif
	set modifiable
endfunction

function DiredInteractiveChdir(files, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	let newfilename = input("cd ")
	silent execute "chdir " . newfilename
	silent call DiredMain(0, a:sid)
endfunction

function DiredOpenWith(files, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	let openwith = input("Open with: ")
	silent execute "!" . openwith . " '" . filename . "' &"
endfunction

" changing attributes

function DiredChangePermissions(files, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	let permissions = DiredGetNumericPermissions(a:files, a:sid)
	let newpermissions = input("New permissions: ", permissions)
	silent execute "!chmod " . newpermissions . " '" . filename . "'"
	silent call DiredMain(0, a:sid)
endfunction

function DiredChangeUser(files, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	let user = DiredGetUser(a:files, a:sid)
	let newuser = input("New user owner: ", user)
	silent execute "!chown '" . newuser . "': '" . filename . "'"
	silent call DiredMain(0, a:sid)
endfunction

function DiredChangeGroup(files, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	let group = DiredGetGroup(a:files, a:sid)
	let newgroup = input("New group owner: ", group)
	silent execute "!chown :'" . newgroup . "' '" . filename . "'"
	silent call DiredMain(0, a:sid)
endfunction

" Other smaller functions

function DiredInfo(files, sid)
	let filename = DiredGetFilename(a:files, a:sid, 0)
	execute "!stat '" . filename . "'"
endfunction

function DiredGitInit(files, sid)
	silent !git init
	silent call DiredMain(0, a:sid)
endfunction

function DiredRefresh(files, sid)
	let g:DiredLine = line('.')
	silent call DiredMain(0, a:sid)
endfunction

function DiredHistoryBack(files, sid)
	if len(g:DiredHistory)
		let dir = g:DiredHistory[-1]
		silent execute "chdir " . dir
		silent call remove(g:DiredHistory, -1)
		silent call DiredMain(0, a:sid)
	endif
endfunction

" Main function

function DiredMain(inNew, sid)
	if a:inNew == 1
		new
	endif
	set modifiable
	set nomodified
	silent execute "e dired:///dired." . a:sid
	let ls = system('ls -la')
	let g:DiredFiles = split(ls, "\n")
	silent put =ls
	silent 1d
	silent execute "normal " . g:DiredLine . "G"
	set nomodifiable
	set nomodified

	" basic operations
	nnoremap <silent><buffer> <Enter> :call DiredChdir(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> dd :call DiredDelete(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> dr :call DiredDeleteRecur(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> r :call DiredRename(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> o :call DiredNewfile(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> m :call DiredMkdir(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> t :call DiredTouch(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> e :call DiredEdit(g:DiredFiles, 0, expand('%:e'))<CR>
	nnoremap <silent><buffer> sp :call DiredEdit(g:DiredFiles, 1, expand('%:e'))<CR>
	nnoremap <silent><buffer> sv :call DiredEdit(g:DiredFiles, 2, expand('%:e'))<CR>

	" utility functions
	nnoremap <silent><buffer> i :call DiredInfo(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> gi :call DiredGitInit(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> cd :call DiredInteractiveChdir(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> O :call DiredOpenWith(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> R :call DiredRefresh(g:DiredFiles, expand('%:e'))<CR>

	" changing attributes
	nnoremap <silent><buffer> cp :call DiredChangePermissions(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> cu :call DiredChangeUser(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> cg :call DiredChangeGroup(g:DiredFiles, expand('%:e'))<CR>
endfunction

let g:DiredLine = 1
let g:DiredHistory = []

nnoremap <silent> <Backspace> :call DiredHistoryBack(g:DiredFiles, expand('%:e'))<CR>

autocmd BufRead,BufNewFile dired:///* set filetype=dired

command DiredHere silent call DiredMain(0, localtime() % 100000)
command Dired silent call DiredMain(1, localtime() % 100000)
