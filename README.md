# terraform-aws-scaffolding
Boilerplate code for an IaaC for AWS

### Archivo de Credenciales Compartido de AWS (~/.aws/credentials)
AWS CLI y SDKs (incluido Terraform por defecto) pueden leer las credenciales desde un archivo de configuración estándar en tu directorio de usuario.

**Cómo configurarlo:**

Crea o edita el archivo `~/.aws/credentials` con el siguiente formato:

```console
[default]
aws_access_key_id = TU_ACCESS_KEY_ID
aws_secret_access_key = TU_SECRET_ACCESS_KEY

[otro-perfil]
aws_access_key_id = OTRA_ACCESS_KEY_ID
aws_secret_access_key = OTRA_SECRET_ACCESS_KEY

```
Asegúrate de que los permisos de este archivo sean restrictivos (solo lectura para el propietario):

```console
chmod 600 ~/.aws/credentials
```

Luego, en tu configuración de Terraform (en main.tf o en un archivo de proveedor), puedes especificar el perfil:

```console
provider "aws" {
  region  = "us-east-1"
  profile = "default" # O el nombre de tu perfil, por ejemplo "otro-perfil"
}
```

**Ventajas:**
- Las credenciales se guardan de forma persistente pero segura en tu sistema local.
- Puedes tener múltiples perfiles para diferentes cuentas o roles.
- Es el método estándar para AWS CLI y muchas herramientas de AWS.