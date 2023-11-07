class MyExceptions implements Exception {
  final String message;

  const MyExceptions([this.message = 'Um erro desconhecido ocorreu.']);

  factory MyExceptions.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const MyExceptions('O e-mail informado já possui um cadastro.');
      case 'invalid-email':
        return const MyExceptions(
          'O e-mail informado é invalido ou foi digitado incorretamente.',
        );
      case 'weak-password':
        return const MyExceptions('Por favor, insira uma senha mais forte.');
      case 'user-disabled':
        return const MyExceptions(
          'Esse usuário foi desabilitado. Por favor entre em contato com o suporte.',
        );
      case 'user-not-found':
        return const MyExceptions(
          'Usuário não encontrado, por favor verifique os dos informados ou crie uma conta.',
        );
      case 'wrong-password':
        return const MyExceptions(
          'E-mail ou senha incorretos, verique e tente novamente.',
        );
      case 'invalid-password':
        return const MyExceptions(
          'E-mail ou senha informados estão incorretos, verifique e tente novamente.',
        );
      case 'invalid-phone-number':
        return const MyExceptions(
          'Telefone informado não é valido. Verique o númeor informado e tente novamente.',
        );
      case 'operation-not-allowed':
        return const MyExceptions('Operação invalida.');
      case 'user-already-verified':
        return const MyExceptions('Usuário já verificado ou não autenticado.');
      case 'too-many-requests':
        return const MyExceptions(
          'Bloqueamos todas as solicitações deste dispositivo devido a atividades incomuns. Tente mais tarde.',
        );
      default:
        return const MyExceptions();
    }
  }
}
