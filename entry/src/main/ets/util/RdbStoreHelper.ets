import { RdbStore } from '../common/database/RdbStore'
import { RdbCharacterHelper } from './RdbCharacterHelper'
import { RdbRoleHelper } from './RdbRoleHelper'


class RdbStoreHelperImpl {
  public async init(store: RdbStore): Promise<void> {
    return new Promise((resolve, reject) => {
      Promise.all([RdbRoleHelper.init(store), RdbCharacterHelper.init(store)]).then(() => {
        resolve()
      }).catch((err) => {
        reject(err)
      })
    })
  }

  public initCharacters(store: RdbStore): Promise<void> {
    return store.createTable('characters', [{
      name: 'id',
      type: 'text',
      primary: true,
      autoincrement: true,
    }, {
      name: 'name',
      type: 'text',
    },
      {
        name: 'icon',
        type: 'text',
      }])
  }
}

export const RdbStoreHelper = new RdbStoreHelperImpl()