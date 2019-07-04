ansible-file-push
=========

push files to remote host.

Features
------------

- push a list of files to remote hosts and you just need to call the `ansible-file-push` role only one time. 

- file path can be either local or an url, also can be a template(You need to define the vars of it, of course).

- support unarchive operation

- support permission and owner settings

- there will be a callback using `nofity` directive of ansible, it can trigger a handler of yourself.

Requirements
------------

ansible: 2.0 + 

My own experiment env is CentOS6/7.

Role Variables
--------------

What you need to pass into the 'file_push' is the `file_list`. And you can define all the variables in this list. Most of them are optional.

When you want push a template file, remember define vars for it and pass them while calling this role.

```yml
    vars:
        file_list:
            ## file which need to be unpacked, the key need to be the directory name. So you need unpack it first and see what it exactly be.
            apache-tomcat-8.5.8:
                name: apache-tomcat-8.5.8.tar.gz
                type: url
                src_path: http://mirrors.hust.edu.cn/apache/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz
                dst_path: /usr/local/tomcat
                need_unpack: 'yes'
                need_clear: 'yes'
                with_owner:
                    user: tomcat
                    group: tomcat
            yum.conf:
                name: yum.conf
                type: file
                src_path: /etc/yum.conf
                dst_path: /etc/yum.conf
                need_unpack: 'no'
                need_clear: 'no'
                with_permission: 700
                with_notify: 'completed'
```

Each item of `file_list`, like `apache-tomcat-8.5.8` and `yum.conf`, can have some vars, as follows.

> note: If the file is a compressed package, the item key should be the dirname after decompressed. For example, in first item, it's `name` is `apache-tomcat-8.5.8.tar.gz`, so the key is `apache-tomcat-8.5.8`. If you don't know what the dir name is, try to decompressed it and check first.

- `name`: the full name of the item. **Required**. `apache-tomcat-8.5.8.tar.gz` if `src_path` is `/tmp/apache-tomcat-8.5.8.tar.gz`, or `http://mirrors.hust.edu.cn/apache/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz`.

- `type`: the type of the item . It's value can be `file(local file)`/`url( url address)`/`tpl(local template file)`. Optional, default 'file' if don't define it. If it is set to 'url', you need to give a 'http(s)://' address in `src_path`. And you can specify a templates while setting this to 'tpl'. Or you need just offer a local path.

- `src_path`/`dst_path`: the source path and the destination, **Required**.

- `need_unpack`: 'yes'/'no'. Optional. It uses the `unarchive` directive of ansible. The prefix can be `tar.gz` or `tar.bz2`, maybe... The file won't be unpacked by default if you don't define it or set it to 'no'.

- `need_clear`: 'yes'/'no'. Optional. At most time you just need clear the compressed package.

- `with_owner`: Optional. Specify the owner of the file on the target hosts. Once set, you need to give the two sub elements: `user` and `group`. Or there will be an error(You can use `ignore_errors: True` to bypass). Note: **the user and the group need to be existed**

- `with_permission`: Optional. same as the `file` module in ansible, default `755`.

- `with_notify`: Optional. Throw a 'notification' to you.

Example Playbook
----------------

There is a simple example in `generals-space.file-push/tests/test_file_push.yml`. First, install it from galaxy, or download from github.

```
$ ansible-galaxy install generals-space.file-push
```

You would get `generals-space.file-push` to `/etc/ansible/roles`, copy the `test_file_push.yml` to your own path. Make sure the `stage` file has the target host group's name and was same of the value of `hosts` in `test_file_push.yml`

```
$ tree
.
├── stage
├── roles
└── test_file_push.yml
```

```
$ ansible-playbook -i ./stage test_file_push.yml
```

License
-------

BSD

Author Information
------------------

general

generals.space@gmail.com
