import 'package:drift/drift.dart';
import 'package:company_print/database/db.dart';
import 'package:company_print/database/models/vehicles.dart';

part 'vehicle_dao.g.dart';

@DriftAccessor(tables: [Vehicles])
class VehicleDao extends DatabaseAccessor<AppDatabase> with _$VehicleDaoMixin {
  final AppDatabase db;

  VehicleDao(this.db) : super(db);

  /// 获取所有车辆列表
  Future<List<Vehicle>> getAllVehicles() async {
    return await select(vehicles).get();
  }

  /// 分页获取车辆列表
  Future<List<Vehicle>> getPaginatedVehicles(
    int offset,
    int limit, {
    String orderByField = 'createdAt', // 默认按照创建时间排序
    bool ascending = false, // 默认倒序
  }) async {
    final query = db.select(db.vehicles)..limit(limit, offset: offset);

    // 定义一个映射来将字符串字段名转换为表中的列
    final columnMap = <String, dynamic>{
      'id': db.vehicles.id,
      'plateNumber': db.vehicles.plateNumber,
      'driverName': db.vehicles.driverName,
      'driverPhone': db.vehicles.driverPhone,
      'createdAt': db.vehicles.createdAt,
    };

    // 检查是否提供了有效的排序字段
    if (columnMap.containsKey(orderByField)) {
      final column = columnMap[orderByField];
      final orderMode = ascending ? OrderingMode.asc : OrderingMode.desc;
      query.orderBy([(t) => OrderingTerm(expression: column, mode: orderMode)]);
    } else {
      // 如果没有提供有效字段，则默认按照创建时间排序，且默认为倒序
      query.orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    }

    return await query.get();
  }

  /// 获取车辆总数
  Future<int> getTotalVehiclesCount() async {
    final count = countAll();
    final countQuery = selectOnly(vehicles)..addColumns([count]);
    final result = await countQuery.map((row) => row.read<int>(count)).getSingle();
    return result ?? 0;
  }

  /// 创建新的车辆信息
  Future<int> createVehicle(Vehicle vehicle) async {
    final entry = VehiclesCompanion(
      plateNumber: Value(vehicle.plateNumber),
      driverName: Value(vehicle.driverName),
      driverPhone: Value(vehicle.driverPhone),
      uuid: Value(vehicle.uuid),
      updatedAt: Value(vehicle.updatedAt),
    );
    return await into(vehicles).insert(entry);
  }

  /// 更新车辆信息
  Future updateVehicle(Vehicle vehicle) async {
    final entry = VehiclesCompanion(
      plateNumber: Value(vehicle.plateNumber),
      driverName: Value(vehicle.driverName),
      driverPhone: Value(vehicle.driverPhone),
      updatedAt: Value(vehicle.updatedAt),
    );
    return await (update(vehicles)..where((tbl) => tbl.id.equals(vehicle.id))).write(entry);
  }

  /// 删除车辆信息
  Future deleteVehicle(int id) async {
    return await (delete(vehicles)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 根据车牌号查找车辆
  Future<List<Vehicle>> getVehiclesByPlateNumber(String plateNumber) async {
    return await (select(vehicles)..where((tbl) => tbl.plateNumber.equals(plateNumber))).get();
  }

  /// 根据司机名称查找车辆
  Future<List<Vehicle>> getVehiclesByDriverName(String driverName) async {
    return await (select(vehicles)..where((tbl) => tbl.driverName.equals(driverName))).get();
  }

  Future<void> insertAllVehicles(List<Vehicle> vehicles) async {
    await batch((batch) {
      batch.insertAll(
        db.vehicles,
        vehicles
            .map(
              (vehicle) => VehiclesCompanion.insert(
                plateNumber: Value(vehicle.plateNumber),
                driverName: Value(vehicle.driverName),
                driverPhone: Value(vehicle.driverPhone),
                uuid: vehicle.uuid,
                updatedAt: Value(vehicle.updatedAt),
              ),
            )
            .toList(),
        mode: InsertMode.insert,
      );
    });
  }
}
