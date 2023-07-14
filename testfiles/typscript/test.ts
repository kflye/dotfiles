let firstName: string = "Dylan";

  
const emptyProfile = (): CurrentProfile => {
  return {
    address: '',
    city: '',
    department: '',
    email: '',
    firstName: '',
    lastName: '',
    fullName: '',
    title: '',
    organizationIds: [],
    id: '',
    legacyId: 0,
    customerUrl: '',
    customerId: '',
    roles: [],
    cultureInfoCode: '',
  };
};

export default class CurrentProfileManager {
  public static Instance = new CurrentProfileManager();
  private currentProfile: CurrentProfile = emptyProfile();

  public getCurrentProfile(): CurrentProfile {
    return this.currentProfile;
  }

  public setCustomerInfo(customerInfo: CustomerInfo) {
    this.currentProfile.customerUrl = customerInfo.compassUrl;
    this.currentProfile.customerId = customerInfo.customerId;
    this.currentProfile.cultureInfoCode = customerInfo.cultureInfoCode;
  }

  public setIdAndLegacyId(id: string, legacyId: number) {
    this.currentProfile.id = id;
    this.currentProfile.legacyId = legacyId;
    this.currentProfile.city = firstName;

    let aa = [1,2,3];
    groupBy(aa, 'prop');
  }
}

type CurrentProfile = {
  address: string;
  city: string;
  department: string;
  email: string;
  firstName: string;
  lastName: string;
  fullName: string;
  title: string;
  organizationIds: string[];
  id: string;
  legacyId: number;
  customerUrl: string;
  customerId: string;
  roles: string[];
  cultureInfoCode: string;
};

export type CustomerInfo = {
  customerId: string;
  compassUrl: string;
  cultureInfoCode: string;
};
