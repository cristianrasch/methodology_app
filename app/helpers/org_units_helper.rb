module OrgUnitsHelper
  def parents_for(org_unit)
    parents = OrgUnit.not_leaves
    parents = OrgUnit.excluding(org_unit) if org_unit.id
    parents
  end
end
