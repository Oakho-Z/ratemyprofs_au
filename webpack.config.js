var path = require('path');

module.exports = {
    entry: './frontend/ratemyprofs.jsx',
    output: {
        path: path.resolve(__dirname, 'public'), // ✅ 更稳妥的路径
        filename: 'bundle.js', // ✅ 不要加 ./
    },
    module: {
        rules: [
            {
                test: [/\.jsx?$/],
                exclude: /(node_modules)/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/env', '@babel/react']
                    }
                },
            }
        ]
    },
    devtool: 'source-map',
    resolve: {
        extensions: ['.js', '.jsx', '*']
    }
};
