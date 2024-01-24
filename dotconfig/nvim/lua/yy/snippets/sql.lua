return {
  parse(
    {
      trig = "create_user",
      desc = "create user",
    },
    [[
CREATE DATABASE ${1};
CREATE USER '${1}_user'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON `${1}`.* TO '${1}_user'@'%';
SHOW GRANTS for ${1}_user;
SHOW GRANTS for '${1}_user'@'%';
  ]]
  ),
}
