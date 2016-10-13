<?php
/**
 * The phpLDAPadmin config file
 * See: http://phpldapadmin.sourceforge.net/wiki/index.php/Config.php
 *
 * 可以在这里覆盖原本定义在lib/config_default.php中的默认设置
 * 主要是一些显示方式方面的选项, 借助于$config->custom这个变量
 * 比如显示语言这个选项, 在默认设置中为
 * $this->default->appearance['language'] = array(
 *  'desc'=>'Language',
 *  'default'=>'auto');
 * 使用下面的方式, 可以覆盖默认设置
 * $config->custom->appearance['language'] = 'en_EN';
*/

// 默认自动检测, 还蛮有效的, 不用显式设置
$config->custom->appearance['language'] = 'zh_CN';

/*
 * 还可以在这个自定义LDAP服务器的连接选项
 * 可以指定多个LDAP服务器, 但必须至少一个
 * 注意:
 * 以"//"注释的行是config_default.php中的默认配置
 * 以"#"注释的行是可以修改成自定义的建议配置

 * 不要修改config_default.php!!! 
 * PLA升级时会将它覆盖掉的, 你的修改将会丢失
 */

/*********************************************
 * Useful important configuration overrides  *
 *********************************************/
// debug模式设置
#  $config->custom->debug['level'] = 255;
#  $config->custom->debug['syslog'] = true;
#  $config->custom->debug['file'] = '/tmp/pla_debug.log';

// PLD可以使用这个变量加密包含有敏感信息的cookie
// 这个数字由localhost.localdomain自动生成...
$config->custom->session['blowfish'] = 'a6d1578cffb16154346314783bb556c3';  

/* If your auth_type is http, you can override your HTTP Authentication Realm. */
// $config->custom->session['http_realm'] = sprintf('%s %s',app_name(),'login');

/* The temporary storage directory where we will put jpegPhoto data
   This directory must be readable and writable by your web server. */
// $config->custom->jpeg['tmpdir'] = '/tmp';     // Example for Unix systems
#  $config->custom->jpeg['tmpdir'] = 'c:\\temp'; // Example for Windows systems

/* Set this to (bool)true if you do NOT want a random salt used when
   calling crypt().  Instead, use the first two letters of the user's
   password.  This is insecure but unfortunately needed for some older
   environments. */
#  $config->custom->password['no_random_crypt_salt'] = true;

/* PHP script timeout control. If php runs longer than this many seconds then
   PHP will stop with an Maximum Execution time error. Increase this value from
   the default if queries to your LDAP server are slow. The default is either
   30 seconds or the setting of max_exection_time if this is null. */
// $config->custom->session['timelimit'] = 30;

// $config->custom->appearance['show_clear_password'] = false;

// $config->custom->search['size_limit'] = 50;
#  $config->custom->search['size_limit'] = 1000;

/* Our local timezone
   This is to make sure that when we ask the system for the current time, we
   get the right local time. If this is not set, all time() calculations will
   assume UTC if you have not set PHP date.timezone. */
// $config->custom->appearance['timezone'] = null;
#  $config->custom->appearance['timezone'] = 'Australia/Melbourne';

/*********************************************
 * Commands                                  *
 *********************************************/

/* Command availability ; if you don't authorize a command the command
   links will not be shown and the command action will not be permitted.
   For better security, set also ACL in your ldap directory. */
/*
$config->custom->commands['cmd'] = array(
    'entry_internal_attributes_show' => true,
    'entry_refresh' => true,
    'oslinks' => true,
    'switch_template' => true
);

$config->custom->commands['script'] = array(
    'add_attr_form' => true,
    'add_oclass_form' => true,
    'add_value_form' => true,
    'collapse' => true,
    'compare' => true,
    'compare_form' => true,
    'copy' => true,
    'copy_form' => true,
    'create' => true,
    'create_confirm' => true,
    'delete' => true,
    'delete_attr' => true,
    'delete_form' => true,
    'draw_tree_node' => true,
    'expand' => true,
    'export' => true,
    'export_form' => true,
    'import' => true,
    'import_form' => true,
    'login' => true,
    'logout' => true,
    'login_form' => true,
    'mass_delete' => true,
    'mass_edit' => true,
    'mass_update' => true,
    'modify_member_form' => true,
    'monitor' => true,
    'purge_cache' => true,
    'query_engine' => true,
    'rename' => true,
    'rename_form' => true,
    'rdelete' => true,
    'refresh' => true,
    'schema' => true,
    'server_info' => true,
    'show_cache' => true,
    'template_engine' => true,
    'update_confirm' => true,
    'update' => true
);
*/

/*********************************************
 * 外观
 *********************************************/

/* If you want to choose the appearance of the tree, specify a class name which
   inherits from the Tree class. */
// $config->custom->appearance['tree'] = 'AJAXTree';
#  $config->custom->appearance['tree'] = 'HTMLTree';

/* Just show your custom templates. */
// $config->custom->appearance['custom_templates_only'] = false;

/* Disable the default template. */
// $config->custom->appearance['disable_default_template'] = false;

/* Hide the warnings for invalid objectClasses/attributes in templates. */
// $config->custom->appearance['hide_template_warning'] = false;

/* Set to true if you would like to hide header and footer parts. */
// $config->custom->appearance['minimalMode'] = false;

/* Configure what objects are shown in left hand tree */
// $config->custom->appearance['tree_filter'] = '(objectclass=*)';

/* The height and width of the tree. If these values are not set, then
   no tree scroll bars are provided. */
// $config->custom->appearance['tree_height'] = null;
#  $config->custom->appearance['tree_height'] = 600;
// $config->custom->appearance['tree_width'] = null;
#  $config->custom->appearance['tree_width'] = 250;

/* Confirm create and update operations, allowing you to review the changes
   and optionally skip attributes during the create/update operation. */
// $config->custom->confirm['create'] = true;
// $config->custom->confirm['update'] = true;

/* Confirm copy operations, and treat them like create operations. This allows
   you to edit the attributes (thus changing any that might conflict with
   uniqueness) before creating the new entry. */
// $config->custom->confirm['copy'] = true;

/*********************************************
 * User-friendly attribute translation       *
 *********************************************/

/* Use this array to map attribute names to user friendly names. For example, if
   you don't want to see "facsimileTelephoneNumber" but rather "Fax". */
// $config->custom->appearance['friendly_attrs'] = array();
$config->custom->appearance['friendly_attrs'] = array(
    'facsimileTelephoneNumber' => 'Fax',
    'gid'                      => 'Group',
    'mail'                     => 'Email',
    'telephoneNumber'          => 'Telephone',
    'uid'                      => 'User Name',
    'userPassword'             => 'Password'
);

/*********************************************
 * 隐藏属性
 *********************************************/

/* You may want to hide certain attributes from being edited. If you want to
   hide attributes from the user, you should use your LDAP servers ACLs.
   NOTE: The user must be able to read the hide_attrs_exempt entry to be
   excluded. */
// $config->custom->appearance['hide_attrs'] = array();
#  $config->custom->appearance['hide_attrs'] = array('objectClass');

/* Members of this list will be exempt from the hidden attributes. */
// $config->custom->appearance['hide_attrs_exempt'] = null;
#  $config->custom->appearance['hide_attrs_exempt'] = 'cn=PLA UnHide,ou=Groups,c=AU';

/*********************************************
 * 只读属性
 *********************************************/

/* You may want to phpLDAPadmin to display certain attributes as read only,
   meaning that users will not be presented a form for modifying those
   attributes, and they will not be allowed to be modified on the "back-end"
   either. You may configure this list here:
   NOTE: The user must be able to read the readonly_attrs_exempt entry to be
   excluded. */
// $config->custom->appearance['readonly_attrs'] = array();

/* Members of this list will be exempt from the readonly attributes. */
// $config->custom->appearance['readonly_attrs_exempt'] = null;
#  $config->custom->appearance['readonly_attrs_exempt'] = 'cn=PLA ReadWrite,ou=Groups,c=AU';

/*********************************************
 * Group属性
 *********************************************/

/* Add "modify group members" link to the attribute. */
// $config->custom->modify_member['groupattr'] = array('member','uniqueMember','memberUid');

/* Configure filter for member search. This only applies to "modify group members" feature */
// $config->custom->modify_member['filter'] = '(objectclass=Person)';

/* Attribute that is added to the group member attribute. */
// $config->custom->modify_member['attr'] = 'dn';

/* For Posix attributes */
// $config->custom->modify_member['posixattr'] = 'uid';
// $config->custom->modify_member['posixfilter'] = '(uid=*)';
// $config->custom->modify_member['posixgroupattr'] = 'memberUid';

/*********************************************
 * Support for attrs display order           *
 *********************************************/

/* Use this array if you want to have your attributes displayed in a specific
   order. You can use default attribute names or their fridenly names.
   For example, "sn" will be displayed right after "givenName". All the other
   attributes that are not specified in this array will be displayed after in
   alphabetical order. */
// $config->custom->appearance['attr_display_order'] = array();
#  $config->custom->appearance['attr_display_order'] = array(
#   'givenName',
#   'sn',
#   'cn',
#   'displayName',
#   'uid',
#   'uidNumber',
#   'gidNumber',
#   'homeDirectory',
#   'mail',
#   'userPassword'
#  );

/*********************************************
 * 这里定义LDAP服务器的各种选项
 *********************************************/

$servers = new Datastore();

/* $servers->NewServer('ldap_pla') must be called before each new LDAP server
   declaration. */
$servers->newServer('ldap_pla');

// 本行第三个参数设置了LDAP服务器的显示名称(像一个logo一样), 
// 这个名称将出现在网页端的左上角, 不作为ID使用, 不具有唯一性
$servers->setValue('server','name','LDAP域管理器');

// LDAP服务器的IP与端口
$servers->setValue('server','host','127.0.0.1');
$servers->setValue('server','port',389);

// LDAP服务器的baseDN, 注意与/etc/openldap/slapd.conf中匹配即可
$servers->setValue('server','base',array('dc=jumpserver,dc=org'));

/* 五种认证方式, 请理智选择:
   1. 'cookie': 通过web表单登录, dn与密码会作为cookie存储在客户端
      使用此方式时, cookie的内容将会被加密, 密钥就是上面的blowfish的值
   2. 'session': 也是通过web表单登录, 但是dn与密码会作为session存储在服务端
   3. 'http': same as session but your login dn and password are retrieved via
      HTTP authentication.
   4. 'config': 在本文件中指定dn与密码, 访问时不需要登录
   5. 'sasl': login will be taken from the webserver's kerberos authentication.
      Currently only GSSAPI has been tested (using mod_auth_kerb).
*/
$servers->setValue('login','auth_type','session');

/* The DN of the user for phpLDAPadmin to bind with. For anonymous binds or
   'cookie','session' or 'sasl' auth_types, LEAVE THE LOGIN_DN AND LOGIN_PASS
   BLANK. If you specify a login_attr in conjunction with a cookie or session
   auth_type, then you can also specify the bind_id/bind_pass here for searching
   the directory for users (ie, if your LDAP server does not allow anonymous
   binds. */
/*
    这里指定PLD可以绑定的DN.
    匿名登录或是使用'cookie', 'session', 'sasl'认证方式时,
    将login.dn与login.pass留空;
    如果使用'cookie'或'session'认证并结合'login.attr'属性时,
    将bind_id与bind_pass
*/
// $servers->setValue('login','bind_id','cn=Manager,dc=example,dc=com');
$servers->setValue('login','bind_id','');

// LDAP管理员密码, 不过如果上面bind_id的值为空的话, 这里也必须留空
// $servers->setValue('login','bind_pass','');
$servers->setValue('login','bind_pass','');

// 使用TLS方式连接LDAP服务器
// $servers->setValue('server','tls',false);

/************************************
 * SASL认证
 ************************************/

/* Enable SASL authentication LDAP SASL authentication requires PHP 5.x
   configured with --with-ldap-sasl=DIR. If this option is disabled (ie, set to
   false), then all other sasl options are ignored. */
// $servers->setValue('login','auth_type','sasl');

/* SASL auth mechanism */
// $servers->setValue('sasl','mech','GSSAPI');

/* SASL authentication realm name */
// $servers->setValue('sasl','realm','');
#  $servers->setValue('sasl','realm','EXAMPLE.COM');

/* SASL authorization ID name
   If this option is undefined, authorization id will be computed from bind DN,
   using authz_id_regex and authz_id_replacement. */
// $servers->setValue('sasl','authz_id', null);

/* SASL authorization id regex and replacement
   When authz_id property is not set (default), phpLDAPAdmin will try to
   figure out authorization id by itself from bind distinguished name (DN).

   This procedure is done by calling preg_replace() php function in the
   following way:

   $authz_id = preg_replace($sasl_authz_id_regex,$sasl_authz_id_replacement,
    $bind_dn);

   For info about pcre regexes, see:
   - pcre(3), perlre(3)
   - http://www.php.net/preg_replace */
// $servers->setValue('sasl','authz_id_regex',null);
// $servers->setValue('sasl','authz_id_replacement',null);
#  $servers->setValue('sasl','authz_id_regex','/^uid=([^,]+)(.+)/i');
#  $servers->setValue('sasl','authz_id_replacement','$1');

/* SASL auth security props.
   See http://beepcore-tcl.sourceforge.net/tclsasl.html#anchor5 for explanation. */
// $servers->setValue('sasl','props',null);

/* Default password hashing algorithm. One of md5, ssha, sha, md5crpyt, smd5,
   blowfish, crypt or leave blank for now default algorithm. */
// $servers->setValue('appearance','password_hash','md5');
$servers->setValue('appearance','password_hash','ssha');

/***
    如果指定'cookie'或'session'作为认证方式, 
    在这里可以选择指定一个登录属性.
    如果这里指定login.attr为'uid', 并且以'dsmith'身份登录,
    PLD将会在目录树中搜索(uid=dsmith)加以验证.
    如果留空, 或将其指定为'dn', 那么登录时需要指定用户的完整DN.
    另外注意, 这种时候, LDAP服务器一般都会在目录树中查询该用户,
    你应该为此指定以何种身份去查询...就在上面的'bind_id'与'bind_pass'里
***/
// $servers->setValue('login','attr','uid');
$servers->setValue('login','attr','dn');

/* Base DNs to used for logins. If this value is not set, then the LDAP server
   Base DNs are used. */
$servers->setValue('login','base',array('dc=jumpserver,dc=org'));

/* If 'login,attr' is used above such that phpLDAPadmin will search for your DN
   at login, you may restrict the search to a specific objectClasses. EG, set this
   to array('posixAccount') or array('inetOrgPerson',..), depending upon your
   setup. */
// $servers->setValue('login','class',array());

/* If you specified something different from 'dn', for example 'uid', as the
   login_attr above, you can optionally specify here to fall back to
   authentication with dn.
   This is useful, when users should be able to log in with their uid, but
   the ldap administrator wants to log in with his root-dn, that does not
   necessarily have the uid attribute.
   When using this feature, login_class is ignored. */
// $servers->setValue('login','fallback_dn',false);

/* Specify true If you want phpLDAPadmin to not display or permit any
   modification to the LDAP server. */
// $servers->setValue('server','read_only',false);
$servers->setValue('server','read_only',false);

/* Specify false if you do not want phpLDAPadmin to draw the 'Create new' links
   in the tree viewer. */
// $servers->setValue('appearance','show_create',true);
$servers->setValue('appearance','show_create',true);

/* Set to true if you would like to initially open the first level of each tree. */
// $servers->setValue('appearance','open_tree',false);
$servers->setValue('appearance','open_tree', true);

/* This feature allows phpLDAPadmin to automatically determine the next
   available uidNumber for a new entry. */
// $servers->setValue('auto_number','enable',true);

/* The mechanism to use when finding the next available uidNumber. Two possible
   values: 'uidpool' or 'search'.
   The 'uidpool' mechanism uses an existing uidPool entry in your LDAP server to
   blindly lookup the next available uidNumber. The 'search' mechanism searches
   for entries with a uidNumber value and finds the first available uidNumber
   (slower). */
// $servers->setValue('auto_number','mechanism','search');

/* The DN of the search base when the 'search' mechanism is used above. */
#  $servers->setValue('auto_number','search_base','ou=People,dc=example,dc=com');

/* The minimum number to use when searching for the next available number
   (only when 'search' is used for auto_number. */
// $servers->setValue('auto_number','min',array('uidNumber'=>1000,'gidNumber'=>500));

/* If you set this, then phpldapadmin will bind to LDAP with this user ID when
   searching for the uidnumber. The idea is, this user id would have full
   (readonly) access to uidnumber in your ldap directory (the logged in user
   may not), so that you can be guaranteed to get a unique uidnumber for your
   directory. */
// $servers->setValue('auto_number','dn',null);

/* The password for the dn above. */
// $servers->setValue('auto_number','pass',null);

/* Enable anonymous bind login. */
// $servers->setValue('login','anon_bind',true);

/* Use customized page with prefix when available. */
#  $servers->setValue('custom','pages_prefix','custom_');

/* If you set this, then only these DNs are allowed to log in. This array can
   contain individual users, groups or ldap search filter(s). Keep in mind that
   the user has not authenticated yet, so this will be an anonymous search to
   the LDAP server, so make your ACLs allow these searches to return results! */
#  $servers->setValue('login','allowed_dns',array(
#   'uid=stran,ou=People,dc=example,dc=com',
#   '(&(gidNumber=811)(objectClass=groupOfNames))',
#   '(|(uidNumber=200)(uidNumber=201))',
#   'cn=callcenter,ou=Group,dc=example,dc=com'));

/* Set this if you dont want this LDAP server to show in the tree */
// $servers->setValue('server','visible',true);

/* Set this if you want to hide the base DNs that dont exist instead of
   displaying the message "The base entry doesnt exist, create it?"
// $servers->setValue('server','hide_noaccess_base',false);
#  $servers->setValue('server','hide_noaccess_base',true);

/* This is the time out value in minutes for the server. After as many minutes
   of inactivity you will be automatically logged out. If not set, the default
   value will be ( session_cache_expire()-1 ) */
#  $servers->setValue('login','timeout',30);

/* Set this if you want phpldapadmin to perform rename operation on entry which
   has children. Certain servers are known to allow it, certain are not. */
// $servers->setValue('server','branch_rename',false);
$servers->setValue('server','branch_rename',true);

/* If you set this, then phpldapadmin will show these attributes as
   internal attributes, even if they are not defined in your schema. */
// $servers->setValue('server','custom_sys_attrs',array(''));
#  $servers->setValue('server','custom_sys_attrs',array('passwordExpirationTime','passwordAllowChangeTime'));

/* If you set this, then phpldapadmin will show these attributes on
   objects, even if they are not defined in your schema. */
// $servers->setValue('server','custom_attrs',array(''));
#  $servers->setValue('server','custom_attrs',array('nsRoleDN','nsRole','nsAccountLock'));

/* These attributes will be forced to MAY attributes and become option in the
   templates. If they are not defined in the templates, then they wont appear
   as per normal template processing. You may want to do this because your LDAP
   server may automatically calculate a default value.
   In Fedora Directory Server using the DNA Plugin one could ignore uidNumber,
   gidNumber and sambaSID. */
// $servers->setValue('server','force_may',array(''));
#  $servers->setValue('server','force_may',array('uidNumber','gidNumber','sambaSID'));

/*********************************************
 * 唯一属性(不允许重名的内容)
 *********************************************/

/* You may want phpLDAPadmin to enforce some attributes to have unique values
   (ie: not belong to other entries in your tree. This (together with
   'unique','dn' and 'unique','pass' option will not let updates to
   occur with other attributes have the same value. */
#  $servers->setValue('unique','attrs',array('mail','uid','uidNumber'));

/* If you set this, then phpldapadmin will bind to LDAP with this user ID when
   searching for attribute uniqueness. The idea is, this user id would have full
   (readonly) access to your ldap directory (the logged in user may not), so
   that you can be guaranteed to get a unique uidnumber for your directory. */
// $servers->setValue('unique','dn',null);

/* The password for the dn above. */
// $servers->setValue('unique','pass',null);

/********************************************************************
 * 如果希望配置额外的LDAP服务器, 按照下面的模板继续配置
 ********************************************************************/

/*
$servers->newServer('ldap_pla');
$servers->setValue('server','name','LDAP Server');
$servers->setValue('server','host','127.0.0.1');
$servers->setValue('server','port',389);
$servers->setValue('server','base',array(''));
$servers->setValue('login','auth_type','cookie');
$servers->setValue('login','bind_id','');
$servers->setValue('login','bind_pass','');
$servers->setValue('server','tls',false);

# SASL auth
$servers->setValue('login','auth_type','sasl');
$servers->setValue('sasl','mech','GSSAPI');
$servers->setValue('sasl','realm','EXAMPLE.COM');
$servers->setValue('sasl','authz_id',null);
$servers->setValue('sasl','authz_id_regex','/^uid=([^,]+)(.+)/i');
$servers->setValue('sasl','authz_id_replacement','$1');
$servers->setValue('sasl','props',null);

$servers->setValue('appearance','password_hash','md5');
$servers->setValue('login','attr','dn');
$servers->setValue('login','fallback_dn',false);
$servers->setValue('login','class',null);
$servers->setValue('server','read_only',false);
$servers->setValue('appearance','show_create',true);

$servers->setValue('auto_number','enable',true);
$servers->setValue('auto_number','mechanism','search');
$servers->setValue('auto_number','search_base',null);
$servers->setValue('auto_number','min',array('uidNumber'=>1000,'gidNumber'=>500));
$servers->setValue('auto_number','dn',null);
$servers->setValue('auto_number','pass',null);

$servers->setValue('login','anon_bind',true);
$servers->setValue('custom','pages_prefix','custom_');
$servers->setValue('unique','attrs',array('mail','uid','uidNumber'));
$servers->setValue('unique','dn',null);
$servers->setValue('unique','pass',null);

$servers->setValue('server','visible',true);
$servers->setValue('login','timeout',30);
$servers->setValue('server','branch_rename',false);
$servers->setValue('server','custom_sys_attrs',array('passwordExpirationTime','passwordAllowChangeTime'));
$servers->setValue('server','custom_attrs',array('nsRoleDN','nsRole','nsAccountLock'));
$servers->setValue('server','force_may',array('uidNumber','gidNumber','sambaSID'));
*/
?>