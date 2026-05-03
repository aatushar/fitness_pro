import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource _datasource;
  ProfileRepositoryImpl(this._datasource);

  @override
  Future<ProfileEntity> getProfile() async {
    final model = await _datasource.getProfile();
    return ProfileEntity(
      id:       model.id,
      username: model.username,
      email:    model.email ?? '',
      roles:    model.roles,
    );
  }
}