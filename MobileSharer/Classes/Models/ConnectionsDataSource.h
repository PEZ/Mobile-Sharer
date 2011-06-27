
#import "ConnectionsModel.h"

@interface ConnectionsDataSource : TTListDataSource {
  ConnectionsModel* _connectionsModel;
}

- (id)initWithConnectionsPath:(NSString*)connectionsPath;

@end
