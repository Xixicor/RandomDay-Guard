<a id="contributing"></a>
# Contribuição

> **Fonte canônica em inglês:** [CONTRIBUTING.md](../../../CONTRIBUTING.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


RandomDayGuard aceita melhorias focadas e reproduzíveis em analisadores, documentação, testes e validação de segurança pública. Mantenha todas as alterações vinculadas ao contrato do projeto público e preserve o comportamento de revisão em primeiro lugar: o Guard deve sair `Admin.ini` inalterado quando uma verificação de segurança necessária não puder ser confirmada.

<a id="prepare-a-safe-workspace"></a>
## Prepare um espaço de trabalho seguro

1. Bifurque ou clone o repositório e crie uma ramificação focada.
2. Instale um interpretador Python 3 compatível. Instale um compilador Lua ao alterar Lua para que `luac -p` possa verificar a sintaxe.
3. Leia a [página inicial da documentação](DOCUMENTA%C3%87%C3%83O.md), [arquitetura](ARQUITETURA.md) e [limite de evidências](LIMITE_DE_EVID%C3%8ANCIAS.md) da área que você alterará.
4. Inspecione `git status` antes de editar e preserve trabalhos não relacionados.
5. Use apenas acessórios sintéticos ou higienizados.

Nunca envie registros de servidores privados, pastas salvas, identificadores de jogadores, `Admin.ini`, endpoints de notificação privados, credenciais, caminhos privados, saída de tempo de execução ou evidências em tempo real copiadas.

<a id="make-a-focused-change"></a>
## Faça uma mudança focada

- Siga a nomenclatura, formatação, verificações de segurança e propriedade de módulos existentes.
- Mantenha um proprietário de documentação canônica para cada procedimento ou fato exato.
- Atualize a documentação do usuário e os exemplos quando o comportamento ou a saída pública mudar.
- Adicione um teste de regressão para uma correção de bug quando for prático.
- Não enfraqueça a confirmação da conta, a proteção de conta confiável, a verificação de backup, a detecção de alterações externas, a comparação de arquivos salvos, a recuperação ou os padrões somente de revisão para fazer um teste passar.

<a id="run-the-relevant-checks"></a>
## Execute as verificações relevantes

Para alterações somente de documentação, execute:

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

Para alterações de origem, configuração, empacotamento ou teste, execute também as verificações aplicáveis em [Validação e revisão de lançamento](VALIDA%C3%87%C3%83O_E_LIBERA%C3%87%C3%83O.md), incluindo verificações de sintaxe Lua, validação de repositório, testes de pipeline público e o conjunto completo de testes unitários. Relate cada verificação ignorada ou indisponível; não o descreva como aprovado.

<a id="submit-the-change-for-review"></a>
## Envie a alteração para revisão

Abra uma solicitação pull focada somente após revisar a comparação completa. Incluem:

- o problema e o comportamento pretendido;
- arquivos exatos e contratos públicos alterados;
- comandos executados e seus resultados;
- privacidade, compatibilidade e impacto na aplicação; e
- limitações restantes ou trabalho de acompanhamento.

Não inclua evidências de tempo de execução geradas ou arquivos de lançamento, a menos que a mudança os exija e valide explicitamente. Uma contribuição não autoriza lançamento, implantação, teste de servidor ativo, ação de aplicação ou publicação em um site de terceiros.

Relate vulnerabilidades por meio da [rota de segurança privada](SEGURAN%C3%87A.md), não de um problema público ou de pull request comum.
