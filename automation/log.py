import logging
import logging.config  # needed when logging_config doesn't start with logging.config

DEFAULT_LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'format1': {
            'format': '%(asctime)s - %(levelname)-5.5s - %(message)s',
        }
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'format1',
        },
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': 'main.log',
            'formatter': 'format1',
        }
    },
    'loggers': {
        'default': {
            'handlers': ['console'],
            'level': 'INFO',
        }
    }
}

def configure_logging():
    logging.config.dictConfig(DEFAULT_LOGGING)
