" Maintainer:   Kacper Kocot <kocotian@kocotian.pl>

function DiredDelete(files, sid)
	let g:DiredLine = line('.')
	let filename = substitute(a:files[g:DiredLine - 1], '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+', '', '')
	silent execute "!rm -f '" . filename . "'>/dev/null"
	echo filename . " removed"
	silent call DiredMain(0, a:sid)
endfunction

function DiredDeleteRecur(files, sid)
	let g:DiredLine = line('.')
	let filename = substitute(a:files[g:DiredLine - 1], '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+', '', '')
	let sure = input("Are you sure that you want to delete " . filename . " recursively? ")
	if sure[0] == 'y'
		silent execute "!rm -rf '" . filename . "'>/dev/null"
		echo filename . " removed recursively"
	endif
	silent call DiredMain(0, a:sid)
endfunction

function DiredChdir(files, sid)
	let g:DiredLine = line('.')
	if substitute(a:files[g:DiredLine - 1], '^\s*', '', '')[0] == 'd'
		let filename = substitute(a:files[g:DiredLine - 1], '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+', '', '')
		silent execute "chdir " . filename
		silent call DiredMain(0, a:sid)
	elseif substitute(a:files[g:DiredLine - 1], '^\s*', '', '')[0] == 'l'
		let filename = substitute(a:files[g:DiredLine - 1], '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+', '', '')
		let filename = substitute(filename, '.*-> ', '', '')
		silent execute "chdir " . filename
		silent call DiredMain(0, a:sid)
	else
		silent call DiredEdit(a:files, 2, a:sid)
	endif
endfunction

function DiredRename(files, sid)
	let g:DiredLine = line('.')
	let filename = substitute(a:files[g:DiredLine - 1], '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+', '', '')
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
	let g:DiredLine = line('.')
	let filename = substitute(a:files[g:DiredLine - 1], '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+', '', '')
	if a:splitted == 0
		silent execute "edit " . filename
	elseif a:splitted == 1
		silent execute "split " . filename
	elseif a:splitted == 2
		silent execute "vsplit " . filename
	endif
	set modifiable
endfunction

function DiredGitInit(files, sid)
	silent !git init
	silent call DiredMain(0, a:sid)
endfunction

function DiredInteractiveChdir(files, sid)
	let g:DiredLine = line('.')
	let filename = substitute(a:files[g:DiredLine - 1], '^\s*\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+', '', '')
	let newfilename = input("cd ", filename)
	silent execute "chdir " . newfilename
	silent call DiredMain(0, a:sid)
endfunction

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

	nnoremap <silent><buffer> dd :call DiredDelete(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> dr :call DiredDeleteRecur(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> <Enter> :call DiredChdir(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> r :call DiredRename(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> o :call DiredNewfile(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> m :call DiredMkdir(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> t :call DiredTouch(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> e :call DiredEdit(g:DiredFiles, 0, expand('%:e'))<CR>
	nnoremap <silent><buffer> sp :call DiredEdit(g:DiredFiles, 1, expand('%:e'))<CR>
	nnoremap <silent><buffer> sv :call DiredEdit(g:DiredFiles, 2, expand('%:e'))<CR>
	nnoremap <silent><buffer> gi :call DiredGitInit(g:DiredFiles, expand('%:e'))<CR>
	nnoremap <silent><buffer> cd :call DiredInteractiveChdir(g:DiredFiles, expand('%:e'))<CR>
endfunction

let g:DiredLine = 1

autocmd BufRead,BufNewFile dired:///* set filetype=dired

command DiredHere silent call DiredMain(0, localtime() % 100000)
command Dired silent call DiredMain(1, localtime() % 100000)
