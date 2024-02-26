import { ICharacterData, RdbCharacterHelper } from '../util/RdbCharacterHelper'
import { IRoleData, RdbRoleHelper } from '../util/RdbRoleHelper'

@Observed
export class DataStore {
  public roles = new Map<string, IRoleData>()
  public characters = new Map<number, ICharacterData>()

  public async init(): Promise<void> {
    const roles = await RdbRoleHelper.getCustomRoles()
    const defaultRoles = RdbRoleHelper.getDefaultRoles()
    this.roles = new Map([...defaultRoles, ...roles].map((v) => [v.id, v]))

    const characters = await RdbCharacterHelper.getCharacters()
    this.characters = new Map([...characters].map((v) => [v.id, v]))
  }
}