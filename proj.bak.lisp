;;;    Projecto de Inteligencia Artificial     ;;;
;;;              1a Entrega                    ;;;
;;;               Grupo 54                     ;;;
;;;             Ana Galvao 75312               ;;;
;;;       Jose Diogo Oliveira 75255            ;;;
;;;             Andre Silva 75455              ;;;
(defconstant T-NLINHAS 18)  ; 0 a 17
(defconstant T-NCOLUNAS 10) ; 0 a 9

;;; cria-accao: inteiro x array -> accao
(defun cria-accao (pos_esq config)
    ; cria par com (posicao da peca, configuracao da peca)
    (cons pos_esq config)
)

;;; accao-coluna: accao-coluna: accao -> inteiro
(defun accao-coluna (accao)
    ; mostra posicao da peca a contar da esquerda
    (car accao)
)

;;; accao-peca: accao -> array
(defun accao-peca(accao)
    ; mostra configuracao da peca
    (cdr accao)
)

;;; cria-tabuleiro {} -> tabuleiro
(defun cria-tabuleiro ()
    ; criar o tabuleiro
    ; devolve tabuleiro vazio
    (make-array (list T-NLINHAS T-NCOLUNAS) :initial-element nil)
)

;;; Aux function copy-arrays
(defun copy-array (array &key
                    (element-type (array-element-type array))
                    (fill-pointer (and (array-has-fill-pointer-p array)
                                       (fill-pointer array)))
                    (adjustable (adjustable-array-p array)))
  (let* ((dimensions (array-dimensions array))
         (new-array (make-array dimensions
                                :element-type element-type
                                :adjustable adjustable
                                :fill-pointer fill-pointer)))
    (dotimes (i (array-total-size array))
      (setf (row-major-aref new-array i)
            (row-major-aref array i)))
    new-array)
)

;;; copia-tabuleiro: tabuleiro -> tabuleiro
(defun copia-tabuleiro (tabuleiro)
    ;funcao para copiar o antigo tabuleiro para um novo
    (copy-array tabuleiro)
)

;;; tabuleiro-preenchido-p: tabuleiro x inteiro x inteiro -> logico
(defun tabuleiro-preenchido-p (tabuleiro nlinha ncoluna)
    ; devolve true se tiver preenchida
    ; nil caso contrario
    (not (null (aref tabuleiro nlinha ncoluna)))
)

;;; tabuleiro-altura-coluna: tabuleiro x inteiro -> inteiro
(defun tabuleiro-altura-coluna (tabuleiro ncoluna)
    ; devolve a posicao mais alta que esteja preenchida
    ; da coluna em questao
    ; devolve zero caso nao esteja preenchida
    ; altura iniciar a ZERO no let, para devolver 0 e nao nil
    ; quando a coluna nao tiver nenhuma peca
    (let ((altura 0))
        (dotimes (lin T-NLINHAS altura)  ; vou percorrer as linhas todas e returnar a altura
            (if (not (null (aref tabuleiro lin ncoluna)))  ; se a current altura nao for nil
                (setf altura (+ lin 1))  ; actualizo a var altura para a mais actual
            )
        )
    )
)

;;; tabuleiro-linha-completa-p: tabuleiro x inteiro -> logico
(defun tabuleiro-linha-completa-p (tabuleiro nlinha)
    ; devolve true se todas as posicoes da linha inteira
    ; estiverem preenchidas
    ; false, otherwise
    (dotimes (col T-NCOLUNAS t)
        (if (null (aref tabuleiro nlinha col)) (return nil))
    )
)

;;; dentro-limites: nlinha x ncoluna -> logico
(defun dentro-limites (nlinha ncoluna)
    ; recebe numero de linha e coluna
    ; devolve True se posicao dentro dos limites
    ; limite das linhas [0, 17]
    ; limite das colunas [0, 9]
    ; ESTAA A FUNCIONAR
    (cond
        ((AND (>= nlinha 0)(< nlinha T-NLINHAS)(>= ncoluna 0)(< ncoluna T-NCOLUNAS)) T)
        (t nil)
    )
)

;;; tabuleiro-preenche!: tabuleiro x inteiro x inteiro -> {}
(defun tabuleiro-preenche! (tabuleiro nlinha ncoluna)
    ; altera o tabuleiro recebido na pos nlinha ncoluna
    ; para ficar preenchido
    ; valida de os valores da nlinha e ncoluna sao validos
    ; (se estao dentro dos limites do campo)
    ; nao interessa o valor devolvido (deve devolver nada)??
    ;(if (AND (AND (>= nlinha 0) (< nlinha T-NLINHAS)) (AND (>= ncoluna 0) (< ncoluna T-NCOLUNAS))) (setf (aref tabuleiro nlinha ncoluna) T) )
    (cond
        ((not (dentro-limites nlinha ncoluna)) nil)
        (t (setf (aref tabuleiro nlinha ncoluna) t))
    )
)

;;; tabuleiro-remove-linha!: tabuleiro x inteiro -> {}
(defun tabuleiro-remove-linha! (tabuleiro nlinha)
    ; remove a nlinha do tabuleiro
    ; fazendo com que as linhas consecutivas, descam
    ; nao interessa o valor devolvido (deve devolver nada)??
    (let ((linha-de-cima nil))
    (dotimes (col T-NCOLUNAS t)
        (loop for lin from nlinha to (- T-NLINHAS 1)
           do (progn
                (cond
                    ((< lin (- T-NLINHAS 1)) (setf linha-de-cima (aref tabuleiro (+ lin 1) col)))
                    (t (setf linha-de-cima nil))
                )
                (setf (aref tabuleiro lin col) linha-de-cima)
            )
        )
    ))
)

;;; tabuleiro-topo-preenchido-p: tabuleiro -> logico
(defun tabuleiro-topo-preenchido-p (tabuleiro)
    ; devolve true se existir uma coluna preenchida
    ; na linha 17 do tabuleiro
    ; ALTEREI PARA DEVOLVER T QUANDO ENCONTRA POSICAO PREENCHIDA E E DEVOLVER NIL CASO NAO ENCONTRE
    (dotimes (col T-NCOLUNAS nil)
        ;(format t "(aref tabuleiro (1- T-NLINHAS) col) = ~d ~%" (aref tabuleiro (1- T-NLINHAS) col))
        (if (aref tabuleiro (1- T-NLINHAS) col) (return t))
    )
)

;;; tabuleiros-iguais-p: tabuleiro x tabuleiro -> logico
(defun tabuleiros-iguais-p (tabuleiro1 tabuleiro2)
    ; devolve true se os 2 tabuleiros tiverem valores iguais
    (equalp tabuleiro1 tabuleiro2)
)

;;; tabuleiro->array: tabuleiro -> array
(defun tabuleiro->array (tabuleiro)
    ; recebe um tabuleiro e devolve um novo array com 18
    ; linhas e 10 colunas que em cada linha e coluna dever conter
    ; o valor logico
    ; o tabuleiro retornado e um novo objecto ( nao o mesmo que o tabuleiro)
    ; http://stackoverflow.com/questions/9549568/common-lisp-convert-between-lists-and-arrays
    (return-from tabuleiro->array tabuleiro)
)

;;; array->tabuleiro: array->tabuleiro
(defun array->tabuleiro (array)
    ; da a entrada do array com 18 linhas e 10 colunas
    ; devolve um tabuleiro object
    ; novo objecto (nao o mesmo que o array)
    ; http://stackoverflow.com/questions/9549568/common-lisp-convert-between-lists-and-arrays
    (return-from array->tabuleiro array)
)

;;; creates type Estado
(defstruct estado
    pontos              ; #num de pontos conseguidos ate ao momento
    pecas-por-colocar   ; lista de pecas ainda por colocar, com ordem de colocacao, letras da peca
    pecas-colocadas     ; lista de pecas ja colocadas, repr pelo simbolo, ordenada pela peca mais antiga
    tabuleiro           ; tabuleiro com as posicoes actualmente preechindas
)

;;; copia-estado: estado->estado
(defun copia-estado (estado)
    ; devolve novo estado cujo conteudo sera copiado do arg
    ; devolve novo objecto, nao destrutivo do antigo
    (make-estado
        :pontos (estado-pontos estado)  ;BUG: e preciso fazer uma copia deste valor
        :pecas-por-colocar (copy-list (estado-pecas-por-colocar estado)) ;usar o copy-list para nao alterar o estado original
        :pecas-colocadas (copy-list (estado-pecas-colocadas estado))
        :tabuleiro (copia-tabuleiro (estado-tabuleiro estado))
    )
    ;(estado-copy estado)
)

;;; estados-iguais-p: estado x estado -> logico
(defun estados-iguais-p (estado1 estado2)
    ; devolve true se os 2 estados forem iguais
    (equalp estado1 estado2)
)

;;; estado-final-p: estado -> logico
(defun estado-final-p (estado)
    ; devolve true caso seja um estado final
    ; (jogador nao pode fazer mais jogadas) (pecas por colocar zerop)
    ; false caso contrario
    ; tiver atingido o topo ou nao tiver mais pecas por colocar
    (OR (zerop (length (estado-pecas-por-colocar estado)))  ; se nao tiver pecas por colocar
        (tabuleiro-topo-preenchido-p (estado-tabuleiro estado)))  ; se tiver o topo preenchido
)

;;;  creates type Problema
(defstruct problema
    estado-inicial  ; estado do problema de procura
    solucao         ; funcao recebe estado e devolve true se for a solucao, nil cc
    accoes          ; funcao recebe estado e devolve lista com acoes que sao possiveis para esse estado
    resultado       ; funcao que dado um estado devolve o estado sucessor  ?? ainda nao percebo ??
    custo-caminho   ; funcao que dado um estado devolve o custo do caminho desde o estado inicial
)

;;; solucao: estado -> logico
(defun solucao (estado)
    ; recebe um estado e devolve true se o estado
    ; recebido for solucao, nil otherwise
    ; solucao (true) se o topo nao tiver preenchido e se nao
    ; existirem pecas por colocar.
    ; (ter pontos nao interessa)
    (AND (zerop (length (estado-pecas-por-colocar estado)))  ;se nao tiver pecas por colocar
         (not (tabuleiro-topo-preenchido-p (estado-tabuleiro estado)))) ;se o topo nao estiver preenchido
)

;;; peca-i: {} -> lista de accoes
; (
;     (0 . #2A((T) (T) (T) (T)))
;     (1 . #2A((T) (T) (T) (T)))
;     (2 . #2A((T) (T) (T) (T)))
;     (3 . #2A((T) (T) (T) (T)))
;     (4 . #2A((T) (T) (T) (T)))  ;
;     (5 . #2A((T) (T) (T) (T)))  ;
;     (6 . #2A((T) (T) (T) (T)))  ;
;     (7 . #2A((T) (T) (T) (T)))  ;
;     (8 . #2A((T) (T) (T) (T)))
;     (9 . #2A((T) (T) (T) (T)))
;     (0 . #2A((T T T T)))
;     (1 . #2A((T T T T)))
;     (2 . #2A((T T T T))) ;
;     (3 . #2A((T T T T))) ;
;     (4 . #2A((T T T T))) ;
;     (5 . #2A((T T T T))) ;
;     (6 . #2A((T T T T)))
; )
(defun peca-i ()
    ; devolve uma lista de accoes correspondentes a peca i
    ; cria uma lista vazia e vai adicionando accoes com as colunas
    ; possiveis para esta peca especifica e com a sua configuracao
    (let (( lista (list) ))
        (dotimes (n T-NCOLUNAS)
            (setf lista (append lista (list (cria-accao n peca-i0))))
        )
        (dotimes (n (- T-NCOLUNAS 3) lista)
            (setf lista (append lista (list (cria-accao n peca-i1))))
        )
    )
)

;;; peca-l: {} -> lista de accoes
; (
;     (0 . #2A((T T) (T NIL) (T NIL)))
;     (1 . #2A((T T) (T NIL) (T NIL)))
;     (2 . #2A((T T) (T NIL) (T NIL)))  ; # Nil
;     (3 . #2A((T T) (T NIL) (T NIL)))  ; # Nil
;     (4 . #2A((T T) (T NIL) (T NIL)))  ; # #
;     (5 . #2A((T T) (T NIL) (T NIL)))
;     (6 . #2A((T T) (T NIL) (T NIL)))
;     (7 . #2A((T T) (T NIL) (T NIL)))
;     (8 . #2A((T T) (T NIL) (T NIL)))
;     (0 . #2A((T NIL NIL) (T T T)))
;     (1 . #2A((T NIL NIL) (T T T)))
;     (2 . #2A((T NIL NIL) (T T T)))
;     (3 . #2A((T NIL NIL) (T T T)))   ; #  #  #
;     (4 . #2A((T NIL NIL) (T T T)))   ; # nil nil
;     (5 . #2A((T NIL NIL) (T T T)))
;     (6 . #2A((T NIL NIL) (T T T)))
;     (7 . #2A((T NIL NIL) (T T T)))
;     (0 . #2A((NIL T) (NIL T) (T T)))
;     (1 . #2A((NIL T) (NIL T) (T T)))
;     (2 . #2A((NIL T) (NIL T) (T T)))  ;   # #
;     (3 . #2A((NIL T) (NIL T) (T T)))  ; nil #
;     (4 . #2A((NIL T) (NIL T) (T T)))  ; nil #
;     (5 . #2A((NIL T) (NIL T) (T T)))
;     (6 . #2A((NIL T) (NIL T) (T T)))
;     (7 . #2A((NIL T) (NIL T) (T T)))
;     (8 . #2A((NIL T) (NIL T) (T T)))
;     (0 . #2A((T T T) (NIL NIL T)))
;     (1 . #2A((T T T) (NIL NIL T)))
;     (2 . #2A((T T T) (NIL NIL T)))
;     (3 . #2A((T T T) (NIL NIL T)))   ; nil nil #
;     (4 . #2A((T T T) (NIL NIL T)))   ; #   #   #
;     (5 . #2A((T T T) (NIL NIL T)))
;     (6 . #2A((T T T) (NIL NIL T)))
;     (7 . #2A((T T T) (NIL NIL T)))
; )
(defun peca-l ()
    ; devolve uma lista de accoes correspondentes a peca l
    ; cria uma lista vazia e vai adicionando accoes com as colunas
    ; possiveis para esta peca especifica e com a sua configuracao
    ; A escolha da orientacao comecar em l0 e passar para l3, l2 e l1,
    ; esta descrito no enunciado que a lista deve comecar pela orientacao inicial da peca
    ; e ir alterando a orientacao rodando a peca 90 graus no sentido horario,
    ; passando para l3 -> l2 -> l1
    (let (( lista (list) ))
        (dotimes (n (1- T-NCOLUNAS))
           (setf lista (append lista (list (cria-accao n peca-l0))))
        )
        (dotimes (n (- T-NCOLUNAS 2))
           (setf lista (append lista (list (cria-accao n peca-l1))))
        )
        (dotimes (n (1- T-NCOLUNAS))
           (setf lista (append lista (list (cria-accao n peca-l2))))
        )
        (dotimes (n (- T-NCOLUNAS 2) lista)
           (setf lista (append lista (list (cria-accao n peca-l3))))
        )

    )
)

;;; peca-j: {} -> lista de accoes
; (
;     (0 . #2A((T T) (NIL T) (NIL T)))
;     (1 . #2A((T T) (NIL T) (NIL T)))
;     (2 . #2A((T T) (NIL T) (NIL T)))
;     (3 . #2A((T T) (NIL T) (NIL T)))  ; Nil #
;     (4 . #2A((T T) (NIL T) (NIL T)))  ; nil #
;     (5 . #2A((T T) (NIL T) (NIL T)))  ;   # #
;     (6 . #2A((T T) (NIL T) (NIL T)))
;     (7 . #2A((T T) (NIL T) (NIL T)))
;     (8 . #2A((T T) (NIL T) (NIL T)))
;     (0 . #2A((T T T) (T NIL NIL)))
;     (1 . #2A((T T T) (T NIL NIL)))
;     (2 . #2A((T T T) (T NIL NIL)))   ; # nil nil
;     (3 . #2A((T T T) (T NIL NIL)))   ; #  #  #
;     (4 . #2A((T T T) (T NIL NIL)))
;     (5 . #2A((T T T) (T NIL NIL)))
;     (6 . #2A((T T T) (T NIL NIL)))
;     (7 . #2A((T T T) (T NIL NIL)))
;     (0 . #2A((T NIL) (T NIL) (T T)))
;     (1 . #2A((T NIL) (T NIL) (T T)))
;     (2 . #2A((T NIL) (T NIL) (T T)))  ; # #
;     (3 . #2A((T NIL) (T NIL) (T T)))  ; # nil
;     (4 . #2A((T NIL) (T NIL) (T T)))  ; # nil
;     (5 . #2A((T NIL) (T NIL) (T T)))
;     (6 . #2A((T NIL) (T NIL) (T T)))
;     (7 . #2A((T NIL) (T NIL) (T T)))
;     (8 . #2A((T NIL) (T NIL) (T T)))
;     (0 . #2A((NIL NIL T) (T T T)))
;     (1 . #2A((NIL NIL T) (T T T)))
;     (2 . #2A((NIL NIL T) (T T T)))   ;   #  #  #
;     (3 . #2A((NIL NIL T) (T T T)))   ; nil nil #
;     (4 . #2A((NIL NIL T) (T T T)))
;     (5 . #2A((NIL NIL T) (T T T)))
;     (6 . #2A((NIL NIL T) (T T T)))
;     (7 . #2A((NIL NIL T) (T T T)))
; )
(defun peca-j ()
    ; devolve uma lista de accoes correspondentes a peca j
    ; cria uma lista vazia e vai adicionando accoes com as colunas
    ; possiveis para esta peca especifica e com a sua configuracao
    ; A escolha da orientacao comecar em j0 e passar para j3, j2 e j1,
    ; esta descrito no enunciado que a lista deve comecar pela orientacao inicial da peca
    ; e ir alterando a orientacao rodando a peca 90 graus no sentido horario,
    ; passando para j3 -> j2 -> j1
    (let (( lista (list) ))
        (dotimes (n (1- T-NCOLUNAS))
           (setf lista (append lista (list (cria-accao n peca-j0))))
        )
        (dotimes (n (- T-NCOLUNAS 2))
           (setf lista (append lista (list (cria-accao n peca-j1))))
        )
        (dotimes (n (1- T-NCOLUNAS))
           (setf lista (append lista (list (cria-accao n peca-j2))))
        )
        (dotimes (n (- T-NCOLUNAS 2) lista)
           (setf lista (append lista (list (cria-accao n peca-j3))))
        )
    )
)

;;; peca-o: {} -> lista de accoes
; (
;     (0 . #2A((T T) (T T)))
;     (1 . #2A((T T) (T T)))
;     (2 . #2A((T T) (T T)))
;     (3 . #2A((T T) (T T))) ; # #
;     (4 . #2A((T T) (T T))) ; # #
;     (5 . #2A((T T) (T T)))
;     (6 . #2A((T T) (T T)))
;     (7 . #2A((T T) (T T)))
;     (8 . #2A((T T) (T T)))
; )
(defun peca-o ()
    ; devolve uma lista de accoes correspondentes a peca o
    ; cria uma lista vazia e vai adicionando accoes com as colunas
    ; possiveis para esta peca especifica e com a sua configuracao
    (let (( lista (list) ))
        (dotimes (n (1- T-NCOLUNAS) lista)
            (setf lista (append lista (list (cria-accao n peca-o0))))
        )
    )
)

;;; peca-s: {} -> lista de accoes
; (
;     (0 . #2A((T T NIL) (NIL T T)))
;     (1 . #2A((T T NIL) (NIL T T)))
;     (2 . #2A((T T NIL) (NIL T T)))
;     (3 . #2A((T T NIL) (NIL T T)))  ; nil # #
;     (4 . #2A((T T NIL) (NIL T T)))  ;   # # Nil
;     (5 . #2A((T T NIL) (NIL T T)))
;     (6 . #2A((T T NIL) (NIL T T)))
;     (7 . #2A((T T NIL) (NIL T T)))
;     (0 . #2A((NIL T) (T T) (T NIL)))
;     (1 . #2A((NIL T) (T T) (T NIL)))
;     (2 . #2A((NIL T) (T T) (T NIL)))
;     (3 . #2A((NIL T) (T T) (T NIL))) ;   # nil
;     (4 . #2A((NIL T) (T T) (T NIL))) ;   # #
;     (5 . #2A((NIL T) (T T) (T NIL))) ; nil #
;     (6 . #2A((NIL T) (T T) (T NIL)))
;     (7 . #2A((NIL T) (T T) (T NIL)))
;     (8 . #2A((NIL T) (T T) (T NIL)))
; )
(defun peca-s ()
    ; devolve uma lista de accoes correspondentes a peca s
    ; cria uma lista vazia e vai adicionando accoes com as colunas
    ; possiveis para esta peca especifica e com a sua configuracao
    (let (( lista (list) ))
        (dotimes (n (- T-NCOLUNAS 2))
            (setf lista (append lista (list (cria-accao n peca-s0))))
        )
        (dotimes (n (1- T-NCOLUNAS) lista)
            (setf lista (append lista (list (cria-accao n peca-s1))))
        )
    )
)

;;; peca-z: {} -> lista de accoes
; (
;     (0 . #2A((NIL T T) (T T NIL)))
;     (1 . #2A((NIL T T) (T T NIL)))
;     (2 . #2A((NIL T T) (T T NIL)))
;     (3 . #2A((NIL T T) (T T NIL)))  ;   # # nil
;     (4 . #2A((NIL T T) (T T NIL)))  ; nil # #
;     (5 . #2A((NIL T T) (T T NIL)))
;     (6 . #2A((NIL T T) (T T NIL)))
;     (7 . #2A((NIL T T) (T T NIL)))
;     (0 . #2A((T NIL) (T T) (NIL T)))
;     (1 . #2A((T NIL) (T T) (NIL T)))
;     (2 . #2A((T NIL) (T T) (NIL T)))
;     (3 . #2A((T NIL) (T T) (NIL T))) ; nil #
;     (4 . #2A((T NIL) (T T) (NIL T))) ;   # #
;     (5 . #2A((T NIL) (T T) (NIL T))) ;   # nil
;     (6 . #2A((T NIL) (T T) (NIL T)))
;     (7 . #2A((T NIL) (T T) (NIL T)))
;     (8 . #2A((T NIL) (T T) (NIL T)))
; )
(defun peca-z ()
    ; devolve uma lista de accoes correspondentes a peca z
    ; cria uma lista vazia e vai adicionando accoes com as colunas
    ; possiveis para esta peca especifica e com a sua configuracao
    (let (( lista (list) ))
        (dotimes (n (- T-NCOLUNAS 2))
            (setf lista (append lista (list (cria-accao n peca-z0))))
        )
        (dotimes (n (1- T-NCOLUNAS) lista)
            (setf lista (append lista (list (cria-accao n peca-z1))))
        )
    )
)

;;; peca-t: {} -> lista de accoes
; (
;     (0 . #2A((T T T) (NIL T NIL)))
;     (1 . #2A((T T T) (NIL T NIL)))
;     (2 . #2A((T T T) (NIL T NIL)))
;     (3 . #2A((T T T) (NIL T NIL))) ; nil # nil
;     (4 . #2A((T T T) (NIL T NIL))) ;   # # #
;     (5 . #2A((T T T) (NIL T NIL)))
;     (6 . #2A((T T T) (NIL T NIL)))
;     (7 . #2A((T T T) (NIL T NIL)))
;     (0 . #2A((T NIL) (T T) (T NIL)))
;     (1 . #2A((T NIL) (T T) (T NIL)))
;     (2 . #2A((T NIL) (T T) (T NIL)))
;     (3 . #2A((T NIL) (T T) (T NIL))) ; # nil
;     (4 . #2A((T NIL) (T T) (T NIL))) ; # #
;     (5 . #2A((T NIL) (T T) (T NIL))) ; # nil
;     (6 . #2A((T NIL) (T T) (T NIL)))
;     (7 . #2A((T NIL) (T T) (T NIL)))
;     (8 . #2A((T NIL) (T T) (T NIL)))
;     (0 . #2A((NIL T NIL) (T T T)))
;     (1 . #2A((NIL T NIL) (T T T)))
;     (2 . #2A((NIL T NIL) (T T T)))
;     (3 . #2A((NIL T NIL) (T T T)))  ;   # # #
;     (4 . #2A((NIL T NIL) (T T T)))  ; nil # nil
;     (5 . #2A((NIL T NIL) (T T T)))
;     (6 . #2A((NIL T NIL) (T T T)))
;     (7 . #2A((NIL T NIL) (T T T)))
;     (0 . #2A((NIL T) (T T) (NIL T)))
;     (1 . #2A((NIL T) (T T) (NIL T)))
;     (2 . #2A((NIL T) (T T) (NIL T)))
;     (3 . #2A((NIL T) (T T) (NIL T))) ; nil #
;     (4 . #2A((NIL T) (T T) (NIL T))) ;   # #
;     (5 . #2A((NIL T) (T T) (NIL T))) ; nil #
;     (6 . #2A((NIL T) (T T) (NIL T)))
;     (7 . #2A((NIL T) (T T) (NIL T)))
;     (8 . #2A((NIL T) (T T) (NIL T)))
;)
(defun peca-t ()
    ; devolve uma lista de accoes correspondentes a peca t
    ; cria uma lista vazia e vai adicionando accoes com as colunas
    ; possiveis para esta peca especifica e com a sua configuracao
    ; A escolha da orientacao comecar em t0 e passar para t3, t2 e t1,
    ; esta descrito no enunciado que a lista deve comecar pela orientacao inicial da peca
    ; e ir alterando a orientacao rodando a peca 90 graus no sentido horario,
    ; passando para t3 -> t2 -> t1
    (let (( lista (list) ))
        (dotimes (n (- T-NCOLUNAS 2))
           (setf lista (append lista (list (cria-accao n peca-t0))))
        )
        (dotimes (n (1- T-NCOLUNAS))
           (setf lista (append lista (list (cria-accao n peca-t1))))
        )
        (dotimes (n (- T-NCOLUNAS 2))
           (setf lista (append lista (list (cria-accao n peca-t2))))
        )
        (dotimes (n (1- T-NCOLUNAS) lista)
           (setf lista (append lista (list (cria-accao n peca-t3))))
        )

    )
)

;;; accoes: estado -> lista de acoes
(defun accoes (estado)
    ; recebe estado devolve lista de accoes validas
    ; acao valida mesmo que faca o jogador perder
    ; acao invalida se nao for fisicamente possivel (< 0 > 10)
    ; !! ordem e importante frente na lista deve estar a order
    ; com que a peca deve estar virada, (orientacao)
    (cond
        ((eq (first (estado-pecas-por-colocar estado)) 'i) (peca-i))
        ((eq (first (estado-pecas-por-colocar estado)) 'l) (peca-l))
        ((eq (first (estado-pecas-por-colocar estado)) 'j) (peca-j))
        ((eq (first (estado-pecas-por-colocar estado)) 'o) (peca-o))
        ((eq (first (estado-pecas-por-colocar estado)) 's) (peca-s))
        ((eq (first (estado-pecas-por-colocar estado)) 'z) (peca-z))
        ((eq (first (estado-pecas-por-colocar estado)) 't) (peca-t))
        (t ())
    )
)

;;; TEST CASE !!!
; (setf x (cria-accao 1 peca-l0))
; (setf tab (cria-tabuleiro))
; (tabuleiro-preenche! tab 0 1)
; (tabuleiro-preenche! tab 0 2)
; (tabuleiro-preenche! tab 0 3)
; (tabuleiro-preenche! tab 0 4)
; (tabuleiro-preenche! tab 1 3)
; (tabuleiro-preenche! tab 2 3)
; (tabuleiro-preenche! tab 3 3)
; (tabuleiro-preenche! tab 4 3)


;;; detecta-colisao: tabuleiro x linha x accao-> logico
(defun detecta-colisao (tabuleiro nlinha accao)
    ; recebe accao, estado e numero da linha
    ; devolve
    ; true caso a peca esteja a coincidir com alguma posicao do tabuleiro(True)
    ; false caso a peca nao coincida com nenhuma posicao preenchida do tabuleiro
    ; METI COMENTARIOS PARA VERES ISTO A FUNCIONARRR!!! TENS UM TEST CASE EM CIMA.  SO DESCOMENTAR E CORRER
    (let (
            (ncoluna (accao-coluna accao))
            (numlinhaspeca (first (array-dimensions (accao-peca accao))))
            (numcolunaspeca (second (array-dimensions (accao-peca accao))))
         )
        ; (format t "ncoluna ~d ~%" ncoluna)
        ; (format t "numlinhaspeca ~d ~%" numlinhaspeca)
        ; (format t "numcolunaspeca ~d ~%" numcolunaspeca)
        (dotimes (l numlinhaspeca nil)
            (dotimes (c numcolunaspeca)
                ;#1 verifica se a posicao que se ira comparar esta dentro dos limites do tabuleiro
                ;#2 verifica se alguma posicao da peca (a True) coincide com alguma posicao do tabuleiro (a True)
                ; (format t "l=~d, c=~d | dentro-limites=~d | tabuleiro-preenchido=~d ~%" l c (dentro-limites (+ nlinha l) (+ ncoluna c)) (tabuleiro-preenchido-p tabuleiro (+ nlinha l) (+ ncoluna c)))
                (if (AND
                        (dentro-limites (+ nlinha l) (+ ncoluna c))  ; #1
                        (tabuleiro-preenchido-p tabuleiro (+ nlinha l) (+ ncoluna c)) ; #2
                    ) (return-from detecta-colisao t) )
            )
        )
    )
)

;;; insere-peca: tabuleiro x peca x nlinha x ncoluna -> {}
(defun insere-peca (tabuleiro peca nlinha ncoluna)
    ; recebe linha e coluna a partir das quais se insere a peca no tabuleiro
    ; nao devolve nada
    (let (
            (numlinhaspeca (first (array-dimensions peca)))
            (numcolunaspeca (second (array-dimensions peca)))

            (lin 0)
            (col 0)
         )
        (dotimes (l numlinhaspeca)
            (dotimes (c numcolunaspeca)
                (setf lin (+ nlinha l))
                (setf col (+ ncoluna c))
                (if (aref peca l c) ;NAO e lin e col mas sim l e c porque lin e col percorrem o tabuleiro e neste if percorre-se a peca
                    (tabuleiro-preenche! tabuleiro lin col)
                )
            )
        )
    )
)

;;; resultado: estado x accao -> estado
(defun resultado (estado accao)
    ; recebe estado e acao e devolve o novo estado que
    ; resultda de aplica a acao ao estado original
    ; NAO e destrutivo, ou seja, novo obejcto e gerado
    ; pseudo algo:
    ; deve actualizar as listas de pecas,
    ; colocar a peca especificada pela accao na posicao correcta
    ; depois de colocada a peca,
    ; verifica se o topo do tabuleiro esta preenchido;
    ; caso sim: nao se removem linhas e devolve-se o estado
    ; case no: removem-se as linhas e calculam-se os pontos obtidos
    (let* (
            (new (copia-estado estado))
            (tabuleiro (estado-tabuleiro new))

            (coluna (accao-coluna accao))
            (peca (accao-peca accao))

            (numcolunaspeca (second (array-dimensions peca)))

            (colunamaior 0)
            (nlinhasremovidas 0)
            (alturacoluna 0)
        )

        ;CICLO DESCOBRIR COLUNA MAIOR DO TABULEIRO (ONDE A PECA PUDERA COLIDIR)
        (dotimes (c numcolunaspeca)
            ;verifica qual das colunas do tabuleiro que estao por baixo da peca e maior
            (setf alturacoluna (tabuleiro-altura-coluna tabuleiro (+ c coluna)))
            (if (> alturacoluna colunamaior)
                (setf colunamaior alturacoluna)
            )
        )
        ; ERROR !!!!
        ;CICLO DE DECREMENTO DAS POSICOES DA PECA NA TABELA ATE COLISAO
        (loop for linha from colunamaior downto 0
            do (cond
                ;Se nao detectar nenhuma colisao e estiver no fundo do tabuleiro (a peca) -> coloca-a nessa posicao
                ((AND (not (detecta-colisao tabuleiro linha accao)) (eq linha 0)) (insere-peca tabuleiro peca linha coluna)) ;ESTAVA AQUI O BUG TESTE 15
                ;Se detectar uma colisao -> coloca a peca na posicao anterior
                ((detecta-colisao tabuleiro linha accao) (insere-peca tabuleiro peca (1+ linha) coluna))
            )
        )

        ;ACTUALIZAR A LISTA DE PECAS COLOCADAS PELA LISTA DE PECAS POR COLOCAR
        (setf (estado-pecas-colocadas new) (append (list (first (estado-pecas-por-colocar new))) (estado-pecas-colocadas new)))

        ;ACTUALIZAR A LISTA DE PECAS POR COLOCAR (RETIRANDO O PRIMEIRO ELEMENTO DA LISTA)
        (setf (estado-pecas-por-colocar new) (rest (estado-pecas-por-colocar new)))

        ;VERIFICA SE ACABOU O JOGO (TOPO PREENCHIDO)
        ;(format t "(estado-pecas-por-colocar new) = ~d ~%" (estado-pecas-por-colocar new))
        ;(format t "(estado-pecas-colocadas new) = ~d ~%" (estado-pecas-colocadas new))
        ;(format t "(tabuleiro-topo-preenchido-p tabuleiro) = ~d ~%" (tabuleiro-topo-preenchido-p tabuleiro))
        (if (tabuleiro-topo-preenchido-p tabuleiro)
            (return-from resultado new) ;Se true: devolve o estado
            (progn ;Se nil: remove linhas e calc pontos calc pontos
                (dotimes (l (1- T-NLINHAS))
                    (cond
                        (
                            (tabuleiro-linha-completa-p tabuleiro l)
                            (progn
                            ;remover as linhas (podemos arranjar forma de nao procurar o tabuleiro todo por uma linha preenchida)
                            (tabuleiro-remove-linha! tabuleiro l)
                            ; incrementa contador de linhas removidas
                            (setf nlinhasremovidas (1+ nlinhasremovidas))
                            ;decrementa o contador porque quando se remove uma linha as outras descem,
                            ;o que provoca um bug se duas linhas completas estiverem juntas.
                            ;exemplo: na linha 0 e na 1 existem linhas completas,
                            ;l=0 -> remove linha -> linhas descem -> a linha 1 que estava completa passa para a linha 0
                            ;contador incrementa -> l=1 -> nao existe...
                            ;LOGO cada vez que se remove uma linha, decrementa-se para apanhar esse caso
                            (setf l (1- l))
                            )

                        )
                        (t ())
                    )
                )

                (cond  ;atribuicao da respectiva pontuacao consoante o numero de linhas removidas
                    ((eq nlinhasremovidas 1) (setf (estado-pontos new) (+ (estado-pontos new) 100)))
                    ((eq nlinhasremovidas 2) (setf (estado-pontos new) (+ (estado-pontos new) 300)))
                    ((eq nlinhasremovidas 3) (setf (estado-pontos new) (+ (estado-pontos new) 500)))
                    ((eq nlinhasremovidas 4) (setf (estado-pontos new) (+ (estado-pontos new) 800)))
                    (t 0)
                )
                ;Tambem tem de se devolver o estado no caso do topo do tabuleiro nao estar preenchido (nao e explicito no enunciado)
                (return-from resultado new)
            )
        )
    )
)

;;; Teste 14
;;; Testes fn resultado
;;deve retornar IGNORE
;; (ignore-value )

;;; qualidade: estado -> inteiro
(defun qualidade (estado)
    ; recebe estado e devolve inteiro que corresponde
    ; ao valor de pontos ganhos ate ao momento em valor negativo.
    ; **** LER COM MAIS ATENCAO ****
    (* -1 (estado-pontos estado))
)

;;; custo-oportunidade: estado -> inteiro
(defun custo-oportunidade (estado)
    ; recebe estado e devolve inteiro que corresponde
    ; nao percebo
    (let (
            (efectivament-conseguido (estado-pontos estado))
            (maximo-possivel 0)
            (todas-pecas (estado-pecas-colocadas estado))
            (custos (make-array (list 7) :initial-element 0))  ; each position corresponds to a letter
        )
        ; acumular todos os custos de todas as acoes ja feitas ate a data
        (dolist (peca todas-pecas)
            ; (format t "peca=~d ~%" peca)
            (cond  ;atribuicao da respectiva pontuacao consoante o numero de linhas removidas
                ((eq peca 'i) (setf (aref custos 0) (+ 800 (aref custos 0))))
                ((eq peca 'j) (setf (aref custos 1) (+ 500 (aref custos 1))))
                ((eq peca 'l) (setf (aref custos 2) (+ 500 (aref custos 2))))
                ((eq peca 's) (setf (aref custos 3) (+ 300 (aref custos 3))))
                ((eq peca 'z) (setf (aref custos 4) (+ 300 (aref custos 4))))
                ((eq peca 't) (setf (aref custos 5) (+ 300 (aref custos 5))))
                ((eq peca 'o) (setf (aref custos 6) (+ 300 (aref custos 6))))
                (t 0)
            )
        )
        ; (format t "custos=~d ~%" custos)
        ; descobrir o maior custo
        (setf maximo-possivel (reduce #'max custos))
        ; (format t "maximo-possivel=~d ~%" maximo-possivel)
        ; (format t "efectivament-conseguido=~d ~%" efectivament-conseguido)
        ; return difference
        (return-from custo-oportunidade (- maximo-possivel efectivament-conseguido))
    )
)


#|
Algoritmos de Procura (2' parte do projecto)
|#
;;; procura-pp: problema -> lista de acoes
(defun procura-pp (problema)
    ; usa procura em profundidade primeiro em arvore
    ; para obter solucao para o problema
    ; devolve lsita de acoes que se executa pela ordem especifica
    ; leva de um estado inicial ao objectivo
    ; deve utilizar LIFO (last in first out)
    ; ultimo n a ser colocado na fronteira dever ser o primeiro a ser explorado.
    ; generico.. nao so para o tetris mas para qualquer problema
    (declare (ignore problema))
)

(defun depth-first-search (estado-inicial solucao been-list moves)
  (cond ((equal estado-inicial solucao)
         (reverse (cons estado-inicial been-list)))
        (t (try-moves estado-inicial solucao been-list moves moves))))

; Try-moves scans down the list of moves in moves-to-try,
; attempting to generate a child state.  If it produces
; this state, it calls depth-first-search to complete the search.

(defun try-moves (estado-inicial solucao been-list moves-to-try moves)
  (cond ((null moves-to-try) nil)
        ((member estado-inicial been-list :test #'equal) nil)
        (t (let ((child (funcall (car moves-to-try) estado-inicial)))
             (if child
               (or (depth-first-search (funcall (car moves-to-try) estado-inicial)
                                       solucao
                                       (cons estado-inicial been-list)
                                       moves)
                   (try-moves estado-inicial solucao been-list (cdr moves-to-try) moves))
               (try-moves estado-inicial solucao been-list (cdr moves-to-try) moves))))))



;;; procura-A*: problema x heuristica -> lista de acoes
(defun procura-A* (problema heuristica)
    ; usa o algo procura A* em arvore para determinar a seq de acoes
    ; de modo a maximizar os pontos obtidos
    ; a funcao euristica corresponde a uma func que recebe um estado
    ; e devolve um numero que corresponde a uma estimativa do custo/qualidade
    ; apartir desse estado ate ao melhor objectivo
    ; em caso de empate entre dois nos com igual valor de f
    ; deve ser escolhido o ultimo a ser colocado
    ; generico.. nao so para o tetris mas para qualuer problema
    ; check pseuso code here -> https://en.wikipedia.org/wiki/A*_search_algorithm#Pseudocode


    (let (
        (close-set nil)
        (open-set nil)
        (came_from nil)
        (g_score nil)



        )

    )
)
(setf prob (make-problema
    :estado-inicial (make-estado
                        :pontos 0
                        :tabuleiro t1
                        :pecas-colocadas ()
                        :pecas-por-colocar '(l j)
                    )
    :solucao #'solucao
    :accoes #'accoes
    :resultado #'resultado
    :custo-caminho #'qualidade))
(setf heur #'(lambda (x) 0))
(procura-A* prob heur)


;;; procura-best: array x listapecas -> lista de acoes
(defun procura-best (array lista-pecas)
    ;;;;;; este e o avaliado
    (declare (ignore array lista-pecas))
)

(load "utils.fas")
;(load (compile-file "utils.lisp"))
