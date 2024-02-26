import relationalStore from '@ohos.data.relationalStore'
import { RdbStore } from './RdbStore'

class RdbUtilImpl {
  public mainDbName = 'test'
  private _dbStores = new Map<string, RdbStore>()

  public async createDB(context: Context, dbName: string): Promise<RdbStore> {
    const STORE_CONFIG = {
      name: `KinshipWealthPath-${dbName}.db`, // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    }

    let rdbStore = this._dbStores.get(dbName)
    if (rdbStore) {
      return
    }

    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    rdbStore = new RdbStore(store)
    this._dbStores.set(dbName, rdbStore)
    return rdbStore
  }

  public getDB(name: string): RdbStore | undefined {
    return this._dbStores.get(name)
  }
}

export const RdbUtil = new RdbUtilImpl()