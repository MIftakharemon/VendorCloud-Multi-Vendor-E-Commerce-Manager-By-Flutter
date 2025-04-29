// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      avatar: fields[0] as dynamic,
      location: fields[1] as Location?,
      id: fields[2] as String?,
      name: fields[3] as String,
      email: fields[4] as String,
      password: fields[5] as String,
      confirmPassword: fields[6] as String?,
      role: fields[7] as String?,
      isActive: fields[8] as bool?,
      isVerified: fields[9] as bool?,
      phoneNumber: fields[10] as String?,
      gender: fields[11] as String?,
      likes: (fields[12] as List?)?.cast<dynamic>(),
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
      v: fields[15] as int?,
      otherPermissions: fields[16] as OtherPermissions?,
      idCardFrontPageImage: fields[17] as dynamic?,
      idCardBackPageImage: fields[18] as dynamic?,
      bankStatementImage: fields[19] as dynamic?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.avatar)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.confirmPassword)
      ..writeByte(7)
      ..write(obj.role)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.isVerified)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.gender)
      ..writeByte(12)
      ..write(obj.likes)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.v)
      ..writeByte(16)
      ..write(obj.otherPermissions)
      ..writeByte(17)
      ..write(obj.idCardFrontPageImage)
      ..writeByte(18)
      ..write(obj.idCardBackPageImage)
      ..writeByte(19)
      ..write(obj.bankStatementImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AvatarAdapter extends TypeAdapter<Avatar> {
  @override
  final int typeId = 1;

  @override
  Avatar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Avatar(
      publicId: fields[0] as String,
      secureUrl: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Avatar obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.publicId)
      ..writeByte(1)
      ..write(obj.secureUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocationAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 2;

  @override
  Location read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Location(
      address1: fields[0] as String?,
      address2: fields[1] as String?,
      city: fields[2] as String,
      state: fields[3] as String,
      postcode: fields[4] as int,
      country: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.address1)
      ..writeByte(1)
      ..write(obj.address2)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.state)
      ..writeByte(4)
      ..write(obj.postcode)
      ..writeByte(5)
      ..write(obj.country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OtherPermissionsAdapter extends TypeAdapter<OtherPermissions> {
  @override
  final int typeId = 3;

  @override
  OtherPermissions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OtherPermissions(
      isVendor: fields[0] as bool?,
      isCustomer: fields[1] as bool?,
      isCategories: fields[2] as bool?,
      isProducts: fields[3] as bool?,
      isOrders: fields[4] as bool?,
      isReviews: fields[5] as bool?,
      isVouchers: fields[6] as bool?,
      isAdManager: fields[7] as bool?,
      isRoleManager: fields[8] as bool?,
      isMessageCenter: fields[9] as bool?,
      isFinance: fields[10] as bool?,
      isShipment: fields[11] as bool?,
      isSupport: fields[12] as bool?,
      isEventManager: fields[13] as bool?,
      isMessage: fields[14] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, OtherPermissions obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.isVendor)
      ..writeByte(1)
      ..write(obj.isCustomer)
      ..writeByte(2)
      ..write(obj.isCategories)
      ..writeByte(3)
      ..write(obj.isProducts)
      ..writeByte(4)
      ..write(obj.isOrders)
      ..writeByte(5)
      ..write(obj.isReviews)
      ..writeByte(6)
      ..write(obj.isVouchers)
      ..writeByte(7)
      ..write(obj.isAdManager)
      ..writeByte(8)
      ..write(obj.isRoleManager)
      ..writeByte(9)
      ..write(obj.isMessageCenter)
      ..writeByte(10)
      ..write(obj.isFinance)
      ..writeByte(11)
      ..write(obj.isShipment)
      ..writeByte(12)
      ..write(obj.isSupport)
      ..writeByte(13)
      ..write(obj.isEventManager)
      ..writeByte(14)
      ..write(obj.isMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtherPermissionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
