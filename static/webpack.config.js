const path = require('path');




module.exports = (env, argv) => ( {
    entry: {
        home: './app/jsx/home.jsx'
    },
    output: {
        path: path.resolve(__dirname, "builds"),
        filename: "bundle.js"
    },
    module: {
        rules: [
            {
                test: /\.(js|jsx)$/,
                exclude: /node_modules/,
                loader: "babel-loader"
            }
        ]
    }
});