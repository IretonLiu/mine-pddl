from minedojo.sim.cmd_executor import CMDExecutor

class CustomCMDExecutor(CMDExecutor):
    def __init__(self, world, raise_error_on_invalid_cmds: bool = False):
        super().__init__(world, raise_error_on_invalid_cmds)