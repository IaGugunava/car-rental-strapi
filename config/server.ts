module.exports = ({ env }) => ({
  host: '0.0.0.0',
  port: env.int('PORT', 1337),
  url: 'https://api.gdd.ge',
  app: { keys: env.array('APP_KEYS') },
});
