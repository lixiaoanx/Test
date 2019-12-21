const path = require('path');

const rootPath = path.resolve(__dirname, '..', '..', 'app', 'javascript');

module.exports = {
  resolve: {
    alias: {
      '@components': path.resolve(rootPath, 'components'),
      '@pages': path.resolve(rootPath, 'pages'),
      '@vendor': path.resolve(rootPath, 'vendor')
    }
  }
};
