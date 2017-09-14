PRAGMA foreign_keys=1;

CREATE TABLE domains (
  name TEXT(255) UNIQUE NOT NULL,
  enabled INTEGER NOT NULL DEFAULT 1,
  dkim_enable INTEGER NOT NULL DEFAULT 1,
  dkim_outbound_all INTEGER NOT NULL DEFAULT 1,
  dkim_privatekey TEXT NOT NULL DEFAULT '',
  dkim_publickey TEXT NOT NULL DEFAULT '',
  dkim_selector TEXT(32) NOT NULL DEFAULT '',
  notes TEXT NOT NULL DEFAULT ''
);
INSERT INTO domains (name, notes) VALUES ('*', 'Global domain to create all-domain mailboxes');

CREATE TABLE mailboxes (
  domain_name TEXT(255) NOT NULL,
  name TEXT(255) NOT NULL,
  password TEXT NOT NULL DEFAULT '',
  enabled INTEGER NOT NULL DEFAULT 1,
  fullname TEXT(255) NOT NULL DEFAULT '',
  send_only INTEGER NOT NULL DEFAULT 0,
  readable INTEGER NOT NULL DEFAULT 1,
  notes TEXT(200) NOT NULL DEFAULT '',
  domain_admin INTEGER NOT NULL DEFAULT 0,
  system_admin INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY(domain_name) REFERENCES domains(name),
  UNIQUE (domain_name, name)
);
INSERT INTO mailboxes (domain_name, name, enabled, readable, notes) VALUES ('*', '*', 0, 0, 'Global mailbox to catch all mail to non-existent mailboxes');

CREATE TABLE aliases (
  domain_name TEXT(255) NOT NULL,
  name TEXT(255) NOT NULL,
  enabled INTEGER NOT NULL DEFAULT 1,
  fullname TEXT(255) NOT NULL DEFAULT '',
  target TEXT NOT NULL,
  notes TEXT(200) NOT NULL DEFAULT '',
  domain_admin INTEGER NOT NULL DEFAULT 0,
  system_admin INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY(domain_name) REFERENCES domains(name),
  UNIQUE (domain_name, name)
);
