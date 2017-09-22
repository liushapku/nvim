
import neovim

# @neovim.plugin
# class Limit(object):
#     def __init__(self, vim):
#         self.vim = vim
#         self.calls = 0

#     @neovim.command('Cmd', range='', nargs='*', sync=True)
#     def command_handler(self, args, range):
#         print(eval)
#         self._increment_calls()
#         self.vim.current.line = (
#             'Command: Called %d times, args: %s, range: %s' % (self.calls,
#                                                                args,
#                                                                range))
#         self.vim.command('echo "Cmd"')

#     @neovim.command('Cmdc',  nargs='*', sync=True, count=3, bang=True, register=True)
#     def count_handler(self, args, bang, register='*'):
#         print(eval)
#         self._increment_calls()
#         self.vim.current.line = (
#             'Command: Called %d times, args: %s, bang: %s, register: %s' % (self.calls,
#                                                                args,
#                                                                bang, register))
#         self.vim.command('echo "Cmd"')

#     @neovim.autocmd('BufEnter', pattern='*.py', eval='expand("<afile>")',
#                     sync=True)
#     def autocmd_handler(self, filename):
#         self._increment_calls()
#         self.vim.current.line = (
#             'Autocmd: Called %s times, file: %s' % (self.calls, filename))

#     @neovim.function('Func')
#     def function_handler(self, args):
#         self._increment_calls()
#         self.vim.current.line = (
#             'Function: Called %d times, args: %s' % (self.calls, args))

#     def _increment_calls(self):
#         if self.calls == 5:
#             raise Exception('Too many calls!')
#         self.calls += 1
