const THEMES_CONFIG = {
    'default': {
        'key': 'default',
        'background_color': '#f6f6f8',
        'alternate_color': '#e2e2e7',
        'ghost_primary': '#ececf0',
        'ghost_secondary': '#f6f6f8',
        'drawer_color': '#ffffff',
        'css_label': 'default-theme',
        'social_theme': 'material-light'
    },
    'dark': {
        'key': 'dark',
        'background_color': '#0a0a0c',
        'alternate_color': '#3d3d46',
        'ghost_primary': '#19191d',
        'ghost_secondary': '#232328',
        'drawer_color': '#131316',
        'css_label': 'dark-theme',
        'social_theme': 'material-dark'
    },
    'light': {
        'key': 'light',
        // warm "paper" palette - deliberately not pure white, distinct from 'default'
        'background_color': '#f0ece3',
        'alternate_color': '#ddd4bd',
        'ghost_primary': '#ece6d9',
        'ghost_secondary': '#f0ece3',
        'drawer_color': '#faf8f3',
        'css_label': 'light-theme',
        'social_theme': 'material-light'
    }
};

export {THEMES_CONFIG};
