Comando para verificar informações do Apache
# httpd -V

Opções Tag <Directory>
    Exembplo:
        <Directory />
            Options FollowSymLinks
            AllowOverride None
            Order deny,allow
            Deny from all
            Allow from 10.0.0.20 192.168.0.25
        </Directory>

    *Options
        - None: Nenhum
        - All: Todas opções habilitadas
        - Indexes: Permite mostrar lista de arquivos se não tiver um index
        - Includes: Permite utilizar SSI (Server Side Include)
        - IncludesNoExec: Permite utilizar SSI exceto o comando "exec" do SSI
        - FollowSymLinks: Permite utilizar Links Simbólicos
        - ExecCGI: Permite executar CGI´s no diretório
        - MultiViews: Permite servir páginas de acordo com a preferência de língua do usuário (index.hml.pt_BR, index.html.en, etc)
    
    *AllowOverride
        - None: Nenhum
        - All: Todas opções habilitadas
        - AuthConfig: Permite configurações de autenticação
        - FileInfo: Permite inclusçaõ de Mime para árvore de diretórios
        - Limit: Permite o controle de acesso por diretório
    
    *Order: Configura ordem de interpretração das regras
        - Bloqueando todo o acesso e liberando apenas um IP
            Order deny,allow
            Deny from all
            Allow from 10.0.0.20
            
        - Liberando todo o acesso e bloquenado apenas um IP
            Order allow,deny
            Allow from all
            Deny from 10.0.0.20