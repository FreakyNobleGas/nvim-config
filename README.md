# README

This repository holds my Neovim config. I am currently using the LazyVim distribution as a starting point while I learn more about Neovim.

## Vim Motion Cheatsheet


### Within a () or {}
NOTE: These commands will also take you to the () or {}. It does not need to be selected.

Select Text
`vi(`
`vi{`

Yank Text
`yi(`
`yi{`

### Around and within a () or {}

Select Text
`va(`
`va{`

Yank Text
`ya(`
`ya{`


### Select text until white space
This is handy for working with lines that end in a semi-colon. You can then paste over it if needed.
`viW` 

### Jump to character

Jump to previous x character
`Fx`

Jump to next x character
`fx`

