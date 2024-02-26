import relationalStore from '@ohos.data.relationalStore'
import { IColumnInfo } from './Interface'

export class RdbStore {
  private _store: relationalStore.RdbStore

  constructor(store: relationalStore.RdbStore) {
    this._store = store
  }

  public createTable(tableName: string, columns: IColumnInfo[]): Promise<void> {
    let sql = `create table if not exists ${tableName}(`;
    for (let column of columns) {
      sql = sql.concat(`${column.name} ${column.type}`);
      sql = sql.concat(`${column.length && column.length > 0 ? `(${column.length})` : ''}`);
      sql = sql.concat(`${column.primary ? ' primary key' : ''}`);
      sql = sql.concat(`${column.autoincrement ? ' autoincrement' : ''}`);
      sql = sql.concat(`${column.nullable ? '' : ' not null'}`);
      sql = sql.concat(', ');
    }
    sql = `${sql.substring(0, sql.length - 2)})`;
    return this.executeSql(sql)

  }

  public deleteTable(tableName: string): Promise<void> {
    const sql = `drop table if exists ${tableName}`
    return this.executeSql(sql)
  }

  public executeSql(sql: string): Promise<void> {
    return new Promise((resolve, reject) => {
      this._store.executeSql(sql).then((res) => {
        resolve(res)
      }).catch((e) => {
        reject(e)
      })
    })
  }

  public queryAll(tableName: string): Promise<relationalStore.ResultSet> {
    return new Promise((resolve, reject) => {
      this._store.querySql(`select * from ${tableName}`).then((res) => {
        resolve(res)
      }).catch((e) => {
        reject(e)
      })
    })
  }

  public query(rdbPredicates: relationalStore.RdbPredicates, columns?: Array<string>): Promise<relationalStore.ResultSet> {
    return new Promise((resolve, reject) => {
      this._store.query(rdbPredicates, columns).then((res) => {
        resolve(res)
      }).catch((e) => {
        reject(e)
      })
    })
  }

  public insert(tableName: string, values: relationalStore.ValuesBucket): Promise<number> {
    return new Promise((resolve, reject) => {
      this._store.insert(tableName, values).then((res) => {
        resolve(res)
      }).catch((e) => {
        reject(e)
      })
    })
  }

  public batchInsert(tableName: string, values: relationalStore.ValuesBucket[]): Promise<number> {
    return new Promise((resolve, reject) => {
      this._store.batchInsert(tableName, values).then((res) => {
        resolve(res)
      }).catch((e) => {
        reject(e)
      })
    })
  }

  public delete(rdbPredicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
      this._store.delete(rdbPredicates).then((res) => {
        resolve(res)
      }).catch((e) => {
        reject(e)
      })
    })
  }

  public update(values: relationalStore.ValuesBucket, rdbPredicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
      this._store.update(values, rdbPredicates).then((res) => {
        resolve(res)
      }).catch((e) => {
        reject(e)
      })
    })
  }
}