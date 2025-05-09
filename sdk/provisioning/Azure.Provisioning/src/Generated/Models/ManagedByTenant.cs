// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

// <auto-generated/>

#nullable enable

using Azure.Provisioning.Primitives;
using System;

namespace Azure.Provisioning.Resources;

/// <summary>
/// Information about a tenant managing the subscription.
/// </summary>
public partial class ManagedByTenant : ProvisionableConstruct
{
    /// <summary>
    /// The tenant ID of the managing tenant. This is a GUID.
    /// </summary>
    public BicepValue<Guid> TenantId 
    {
        get { Initialize(); return _tenantId!; }
    }
    private BicepValue<Guid>? _tenantId;

    /// <summary>
    /// Creates a new ManagedByTenant.
    /// </summary>
    public ManagedByTenant()
    {
    }

    /// <summary>
    /// Define all the provisionable properties of ManagedByTenant.
    /// </summary>
    protected override void DefineProvisionableProperties()
    {
        base.DefineProvisionableProperties();
        _tenantId = DefineProperty<Guid>("TenantId", ["tenantId"], isOutput: true);
    }
}
