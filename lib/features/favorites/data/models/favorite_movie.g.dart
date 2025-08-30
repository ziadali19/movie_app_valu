// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteMovieAdapter extends TypeAdapter<FavoriteMovie> {
  @override
  final int typeId = 0;

  @override
  FavoriteMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteMovie(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String?,
      voteAverage: fields[3] as double,
      releaseDate: fields[4] as String,
      overview: fields[5] as String,
      addedAt: fields[6] as DateTime,
      voteCount: fields[7] as int,
      genreIds: (fields[8] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteMovie obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.voteAverage)
      ..writeByte(4)
      ..write(obj.releaseDate)
      ..writeByte(5)
      ..write(obj.overview)
      ..writeByte(6)
      ..write(obj.addedAt)
      ..writeByte(7)
      ..write(obj.voteCount)
      ..writeByte(8)
      ..write(obj.genreIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
