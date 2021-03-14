" Vim syntax file
" Language:		Dired
" Maintainer:	Kacper Kocot <kocotian@kocotian.pl>
" Last Change:	2021 Mar 14

syn match diredTotalValue	display contained "\s*[0-9]*"
syn match diredTotal		display "^total\s" contains=diredTotalValue

syn match diredDirectory	display "^d.*" contains=diredPermissions,diredDirCount,diredUser,diredGroup,diredSize,diredModifyDate,diredFilename
syn match diredFifo			display "^p.*" contains=diredPermissions,diredDirCount,diredUser,diredGroup,diredSize,diredModifyDate,diredFilename
syn match diredLink			display "^l.*" contains=diredPermissions,diredDirCount,diredUser,diredGroup,diredSize,diredModifyDate,diredFilename
syn match diredFile			display "^-.*" contains=diredPermissions,diredDirCount,diredUser,diredGroup,diredSize,diredModifyDate

syn match diredPermissions	display contained "^.........." contains=diredPermRead,diredPermWrite,diredPermExecute
syn match diredPermRead		display contained "r"
syn match diredPermWrite	display contained "w"
syn match diredPermExecute	display contained "x"
syn match diredPermNone		display contained "-" contains=diredPermFile
syn match diredPermFile		display contained "^-"

syn match diredDirCount		display contained "^\S\+\s\+\S\+" contains=diredPermissions
syn match diredRoot			display contained "root"
syn match diredUser			display contained "^\S\+\s\+\S\+\s\+\S\+" contains=diredPermissions,diredDirCount,diredRoot
syn match diredGroup		display contained "^\S\+\s\+\S\+\s\+\S\+\s\+\S\+" contains=diredPermissions,diredDirCount,diredUser,diredRoot

syn match diredSize			display contained "^\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+" contains=diredPermissions,diredDirCount,diredUser,diredGroup
syn match diredModifyDate	display contained "^\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+\s\+\S\+" contains=diredPermissions,diredDirCount,diredUser,diredGroup,diredSize

hi def link diredTotal			Keyword
hi def link diredTotalValue		Number

hi def link diredDirectory		Structure
hi def link diredFifo			Repeat
hi def link diredLink			String
hi def link diredFile			Normal

hi def link diredPermissions	DiredNoperm
hi def link diredPermRead		DiredRead
hi def link diredPermWrite		DiredWrite
hi def link diredPermExecute	DiredExecute
hi def link diredPermFile   	DiredNoperm

hi def link diredRoot			DiredRoot
hi def link diredUser			DiredUser
hi def link diredGroup			DiredGroup

hi def link diredSize			Number
hi def link diredModifyDate		DiredModifyDate

hi def link diredDirCount		Number

let b:current_syntax = "dired"
