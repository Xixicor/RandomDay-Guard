<a id="install-randomdayguard"></a>
# Instalar RandomDayGuard

> **Fonte canônica em inglês:** [INSTALL.md](../../../INSTALL.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Este guia instala `v0.4.12-alpha` em um servidor dedicado do Fator Abiótico que já usa UE4SS. O mod não está vinculado a uma empresa de hospedagem ou painel de controle.

<a id="before-you-begin"></a>
## Antes de começar

Você precisa de:

- acesso para parar e iniciar o servidor dedicado;
- a UE4SS `Mods` pasta;
- uma cópia da pasta RandomDayGuard atual do servidor, se você estiver atualizando;
- um backup dos dados do servidor que você normalmente protege antes de alterar um mod.

O **pasta Mods** é a `ue4ss/Mods/` diretório dentro da instalação do servidor dedicado. RandomDayGuard pertence diretamente a essa pasta.

<a id="new-installation"></a>
## Nova instalação

1. Pare o servidor dedicado.
2. Extraia o RandomDayGuard ZIP para uma nova pasta vazia.
3. Copie o extraído `RandomDayGuard` na pasta UE4SS `Mods` pasta. O resultado deve ser um `Mods/RandomDayGuard/` do servidor, não em uma segunda pasta RandomDayGuard aninhada dentro dela.
4. Aberto UE4SS `mods.txt` e habilite:

   ```text
   RandomDayGuard : 1
   ```

5. Inicie o servidor normalmente.
6. Aguarde UE4SS e o servidor do jogo para terminar de iniciar, siga [Ler o primeiro relatório](COMECE_AQUI.md).

Não copie uma nova versão em uma instalação em execução. Mantenha o backup até que a instalação atualizada produza um relatório atual de status do servidor.

<a id="update-an-existing-installation"></a>
## Atualizar uma instalação existente

1. Pare o servidor.
2. Copie a pasta RandomDayGuard instalada completa para um local de backup seguro.
3. Mova a pasta antiga do programa para fora de UE4SS `Mods` em vez de colocar a nova versão em camadas sobre ela.
4. Copie a nova pasta RandomDayGuard para `Mods`.
5. Restaure apenas a configuração local revisada e as evidências salvas. Se o guia de configuração listar novos campos, mescle-os na cópia revisada em vez de substituir todas as configurações às cegas.
6. Confirme `RandomDayGuard : 1` permanece ativado.
7. Inicie o servidor e leia o relatório de status do servidor atual.

Esta atualização de pasta limpa também remove arquivos obsoletos de versões mais antigas sem pedir ao operador para inspecionar o programa nomes de arquivos.

<a id="help-guard-find-the-server-records"></a>
## Ajuda o Guard a encontrar os registros do servidor

O Guard normalmente encontra o diretório do Fator Abiótico `Saved` automaticamente. Se não puder, coloque o caminho completo para esse diretório `Saved` em `SavedRoot.txt` dentro de RandomDayGuard pasta. Aponte para `Saved`, não para um mundo individual abaixo dele.

O primeiro relatório de status do servidor informa se o local do registro foi encontrado e quais grupos de origem estavam disponíveis. Use [Solução de problemas](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md) quando não puder ler a localização.

<a id="first-run-behavior"></a>
## Comportamento de primeira execução

A instalação padrão observa os registros disponíveis e grava relatórios. Isso não altera `Admin.ini` nem adiciona banimento. Isso permite que você confirme a qualidade da coleta, tradução e relatório antes de decidir se deseja ativar qualquer ação opcional.

[Ler o primeiro relatório](COMECE_AQUI.md)

<a id="disable-or-remove-randomdayguard"></a>
## Desativar ou remover RandomDayGuard

1. Pare o servidor.
2. Copiar a pasta RandomDayGuard completa para um arquivo seguro.
3. Para desativar o mod, defina `RandomDayGuard : 0` em UE4SS `mods.txt`.
4. Para removê-la, mova a pasta RandomDayGuard completa para fora de `Mods` após a confirmação, o arquivo pode ser aberto.
5. Inicie o servidor e confirme se o Guard não inicia mais.

Desativar ou remover o Guard interrompe coletas futuras. Ele não exclui dados do jogo, não apaga os relatórios arquivados nem reverte uma ação separada do operador.

<a id="roll-back-an-update"></a>
## Reverter uma atualização

Se a nova instalação não carregar ou não puder produzir um relatório atual:

1. Pare o servidor.
2. Mova a instalação malsucedida de lado sem excluir seus registros.
3. Restaure a pasta RandomDayGuard de pré-atualização completa.
4. Restaure a configuração revisada e as evidências salvas do mesmo backup.
5. Confirme se o mod está ativado e inicie o servidor.
6. Leia o relatório de status do servidor restaurado antes de fazer outra alteração.

<a id="more-help"></a>
## Mais ajuda

- [Ler o primeiro relatório](COMECE_AQUI.md)
- [Manual de operações](MANUAL_DE_OPERA%C3%87%C3%95ES.md)
- [Solução de problemas](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md)
- [Perfis de configuração](PERFIS_DE_CONFIGURA%C3%87%C3%83O.md)
- [Admin.ini aplicação](APLICA%C3%87%C3%83O_DE_INICIALIZA%C3%87%C3%83O_ADMINISTRATIVA.md)

Os mantenedores da versão podem encontrar verificações de origem, pacote e privacidade em [Validação e lançamento](VALIDA%C3%87%C3%83O_E_LIBERA%C3%87%C3%83O.md). Eles não são necessários para uma instalação comum.
