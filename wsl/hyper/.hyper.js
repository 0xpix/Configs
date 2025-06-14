"use strict";

module.exports = {
    config: {
        // Update settings
        updateChannel: 'stable',
        disableAutoUpdates: false,

        // Font settings
        fontSize: 14,
        fontFamily: 'Hasklug Nerd Font',
        fontWeight: 'normal',
        lineHeight: 1.2,
        letterSpacing: 0,
        disableLigatures: false,

        // Terminal appearance
        padding: '12px 14px',
        activeTab: "🧑‍💻",
        cursorColor: 'rgba(248,28,229,0.8)',
        cursorShape: 'BLOCK',
        cursorBlink: false,
        foregroundColor: '#fff',
        backgroundColor: '#000',
        selectionColor: 'rgba(248,28,229,0.3)',
        borderColor: '#333',

        // Color scheme
        colors: {
            black: '#000000', red: '#C51E14', green: '#1DC121', yellow: '#C7C329',
            blue: '#0A2FC4', magenta: '#C839C5', cyan: '#20C5C6', white: '#C7C7C7',
            lightBlack: '#686868', lightRed: '#FD6F6B', lightGreen: '#67F86F',
            lightYellow: '#FFFA72', lightBlue: '#6A76FB', lightMagenta: '#FD7CFC',
            lightCyan: '#68FDFE', lightWhite: '#FFFFFF', limeGreen: '#32CD32', lightCoral: '#F08080',
        },

        // Custom CSS
        css: '',
        termCSS: 'font-variant-ligatures: initial;',

        // Environment & shell
        shell: 'C:\\Windows\\System32\\wsl.exe',
        shellArgs: ['-d', 'ubuntu'],
        env: {
            TERM: 'xterm-256color',
        },
        preserveCWD: true,

        // Behavior settings
        bell: 'SOUND',
        copyOnSelect: true,
        defaultSSHApp: true,
        quickEdit: true,
        macOptionSelectionMode: 'vertical',
        screenReaderMode: false,
        webGLRenderer: true,
        webLinksActivationKey: '',

        // Keyboard shortcuts
        keys: {
            'Ctrl+K': 'editor:clearBuffer',
            'Ctrl+Shift+T': 'window:new',
            'Ctrl+Shift+N': 'window:new',
            'Ctrl+Tab': 'tab:next',
            'Ctrl+Shift+Tab': 'tab:prev',
        },

        // Plugin-specific settings
        hyperTabs: {
            trafficButtons: true,
            tabIcons: true,
            tabIconsColored: true,
        },
        hyperline: {
            plugins: [
                'ip', 'cpu', 'network', 'memory', 'gitstatus', 'vibrancy'
            ],
        },
    },

    // Plugins
    plugins: [
        // Visual enhancements
        "hyper-snazzy",              // Beautiful color scheme

        // Functionality
        "hyper-pane",                // Pane navigation and management
        "hyper-active-tab",          // Highlights active tab
        "hyper-font-ligatures",      // Enables font ligatures
        "hyperline",                // Status line for terminal
    ],

    localPlugins: [],
    keymaps: {},
};
