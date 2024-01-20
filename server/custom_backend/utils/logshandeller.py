# import logging
# import colorlog
# from fastapi.logger import logger as fastapi_logger

# handler = logging.StreamHandler()
# logging.getLogger().setLevel(logging.NOTSET)
# handler.setFormatter(colorlog.ColoredFormatter(
#     '%(log_color)s%(levelname)-8s%(reset)s - %(asctime)s - %(message)s',
#     log_colors={
#         'DEBUG': 'cyan',
#         'INFO': 'green',
#         'WARNING': 'yellow',
#         'ERROR': 'red',
#         'CRITICAL': 'red,bg_white',
#     },
#     datefmt='%Y-%m-%d %H:%M:%S'
# ))
# fastapi_logger.addHandler(handler)