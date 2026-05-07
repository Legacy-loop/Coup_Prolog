:- dynamic rainha/2.
iniciar :-
    retractall(rainha(_,_)),
    write('===================================='), nl,
    write('     PROBLEMA DAS 8 RAINHAS'), nl,
    write('===================================='), nl,
    nl,
    write('Comandos disponiveis:'), nl,
    write('  (Linha,Coluna).  -> adiciona rainha'), nl,
    write('  lista.           -> lista rainhas'), nl, 
    write('  sair.            -> encerra o jogo'), nl,
    nl,
    imprimir_tabuleiro,
    loop_jogo.
loop_jogo :-

    verificar_vitoria,

    nl,
    write('Digite um comando: '),
    nl,

    read(Entrada),

    processar_entrada(Entrada).
processar_entrada(sair) :-
    write('Encerrando jogo...'), nl.

processar_entrada(lista) :-
    listar_rainhas,
    loop_jogo.

processar_entrada((Linha,Coluna)) :-

    tentar_jogada(Linha, Coluna),

    loop_jogo.

processar_entrada(_) :-
    write('Entrada invalida!'), nl,
    loop_jogo.

tentar_jogada(Linha, Coluna) :-

    (
        valido(Linha, Coluna)
    ->
        (
            rainha(Linha, Coluna)
        ->
            write('Ja existe uma rainha nessa posicao!'), nl
        ;
            (
                conflito_com_alguma(Linha, Coluna)
            ->
                write('Posicao invalida: conflito com outra rainha!'), nl
            ;
                assertz(rainha(Linha, Coluna)),
                write('Rainha adicionada com sucesso!'), nl
            )
        )
    ;
        write('Posicao invalida! Use valores de 1 a 8.'), nl
    ),

    imprimir_tabuleiro.

valido(L, C) :-
    between(1,8,L),
    between(1,8,C).

conflito(L1,C1,L2,C2) :-
    L1 =:= L2 ;
    C1 =:= C2 ;
    abs(L1 - L2) =:= abs(C1 - C2).

conflito_com_alguma(L,C) :-
    rainha(L2,C2),
    conflito(L,C,L2,C2).

verificar_vitoria :-

    findall((L,C), rainha(L,C), Lista),

    length(Lista, 8),

    nl,
    write('===================================='), nl,
    write(' PARABENS! VOCE RESOLVEU O PROBLEMA'), nl,
    write('===================================='), nl,
    nl,

    imprimir_tabuleiro,

    !.

verificar_vitoria.

casa(Linha, Coluna, '■') :-
    (Linha + Coluna) mod 2 =:= 0.

casa(Linha, Coluna, '□') :-
    (Linha + Coluna) mod 2 =:= 1.

imprimir_tabuleiro :-

    nl,
    write('=   1 2 3 4 5 6 7 8'), nl,

    forall(
        between(1,8,Linha),

        (
            write(Linha),
            write('  '),

            forall(
                between(1,8,Coluna),

                (
                    (
                        rainha(Linha,Coluna)
                    ->
                        write('Q ')
                    ;
                        (
                            casa(Linha,Coluna,Simbolo),
                            write(Simbolo),
                            write(' ')
                        )
                    )
                )
            ),

            nl
        )
    ),

    nl.

segura(L,C) :-
    valido(L,C),
    \+ conflito_com_alguma(L,C).

listar_rainhas :-

    findall((L,C), rainha(L,C), Lista),

    nl,
    write('Rainhas atuais:'), nl,
    write(Lista),
    nl.
