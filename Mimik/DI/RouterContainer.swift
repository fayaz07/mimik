//
//  Router.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//
import Factory

extension Container {
  var workspaceRouter: Factory<WorkspaceRouter> {
    self { WorkspaceRouter() }
  }
}
