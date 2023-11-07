class SignUpWithEmailAndPasswordFailure implements Exception{
  final String message;

  const SignUpWithEmailAndPasswordFailure([this.message = "Ocorreu um erro desconhecido."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure('Por favor, insira uma senha mais forte.');
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure('O e-mail não é válido ou está mal formatado.');
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure('Já existe uma conta para esse e-mail.');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure('Este usuário foi desativado. Entre em contato com o suporte para obter ajuda.');
      case 'too-many-requests':
        return const SignUpWithEmailAndPasswordFailure('Demasiados pedidos, serviço temporariamente bloqueado.');
      case 'invalid-argument':
        return const SignUpWithEmailAndPasswordFailure('Um argumento inválido foi fornecido para um método de autenticação.');
      case 'invalid-password':
        return const SignUpWithEmailAndPasswordFailure('Senha incorreta. Por favor tente novamente.');
      case 'invalid-phone-number':
        return const SignUpWithEmailAndPasswordFailure('O número de telefone fornecido é inválido.');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure('O provedor de login fornecido está desativado para seu projeto do Firebase.');
      case 'session-cookie-expired':
        return const SignUpWithEmailAndPasswordFailure('O cookie de sessão do Firebase fornecido expirou.');
      case 'uid-already-exists':
        return const SignUpWithEmailAndPasswordFailure('O uid fornecido já está em uso por um usuário existente.');
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}